import 'dart:io';
import 'package:filipino_food_scanner/screens/home_screen.dart';
import 'package:filipino_food_scanner/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'session_manager.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.bantayallerji://reset-password',
      );

      _isLoading = false;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      switch (e.statusCode) {
        case '400':
          return 'Invalid email address';
        case '429':
          return 'Too many requests. Please try again later';
        default:
          return e.message;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'An unexpected error occurred. Please try again';
    }
  }

  Future<String?> resetPassword(String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      _isLoading = false;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to reset password. Please try again';
    }
  }

  Widget showAlert(context, String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }

  Future<void> initialize() async {
    print('🔄 Initializing Auth Service...');

    try {
      // STEP 1: Check local session FIRST (works offline)
      final hasLocalSession = await SessionManager.isLoggedIn();

      if (hasLocalSession) {
        print('📱 Local session found, loading user data...');

        // Try to load user from local storage
        final localUser = await SessionManager.getUserData();

        if (localUser != null) {
          _currentUser = localUser;
          print('✅ User loaded from local storage: ${localUser.email}');
          _isInitialized = true;
          notifyListeners();

          // Try to sync with server in background (don't wait)
          _syncWithServer();
          return;
        }
      }

      // STEP 2: Check Supabase session (requires internet)
      print('🌐 Checking Supabase session...');
      final session = _supabase.auth.currentSession;

      if (session != null && !session.isExpired) {
        print('✅ Supabase session found: ${session.user.email}');

        // Load profile from server
        await _loadUserProfileFromServer(session.user.id);
      } else {
        print('ℹ️ No valid session found');
      }

      // Listen for auth state changes
      _supabase.auth.onAuthStateChange.listen((data) {
        final event = data.event;
        print('🔔 Auth event: $event');

        if (event == AuthChangeEvent.signedIn) {
          print('✅ User signed in');
          if (data.session?.user != null) {
            _loadUserProfileFromServer(data.session!.user.id);
          }
        } else if (event == AuthChangeEvent.signedOut) {
          print('👋 User signed out');
          _currentUser = null;
          SessionManager.clearSession();
          notifyListeners();
        } else if (event == AuthChangeEvent.tokenRefreshed) {
          print('🔄 Token refreshed');
          SessionManager.refreshSession();
        }
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('❌ Error initializing auth: $e');

      // Even if initialization fails, try local session
      final localUser = await SessionManager.getUserData();
      if (localUser != null) {
        _currentUser = localUser;
        print('✅ Fallback: User loaded from local storage');
      }

      _isInitialized = true;
      notifyListeners();
    }
  }

  // Sync with server in background (don't block UI)
  Future<void> _syncWithServer() async {
    try {
      print('🔄 Syncing with server...');
      final session = _supabase.auth.currentSession;

      if (session != null && !session.isExpired) {
        await _loadUserProfileFromServer(session.user.id);
        print('✅ Sync complete');
      }
    } catch (e) {
      print('⚠️ Sync failed (offline?): $e');
      // Ignore sync errors - we already have local data
    }
  }

  // Future<String?> register({
  //   context,
  //   required String email,
  //   required String firstName,
  //   String? middleName,
  //   required String lastName,
  //   String? contactNo,
  //   required List<String> allergies,
  // }) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();

  //     print('📝 Registering user: $email');

  //     final AuthResponse response = await _supabase.auth.signUp(
  //       email: email,
  //       password: password,
  //     );

  //     if (response.user == null) {
  //       _isLoading = false;
  //       notifyListeners();
  //       return 'Failed to create account';
  //     }

  //     print('✅ Auth user created: ${response.user!.id}');

  //     await _supabase.from('profiles').upsert({
  //       'id': response.user!.id,
  //       'email': email,
  //       'first_name': firstName,
  //       'middle_name': middleName,
  //       'last_name': lastName,
  //       'contact_no': contactNo,
  //       'allergies': allergies,
  //     });

  //     print('✅ Profile created');

  //     await _loadUserProfileFromServer(response.user!.id);

  //     _isLoading = false;
  //     notifyListeners();

  //     return null;
  //   } on AuthException catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return showAlert(context, "Error", e.message);
  //         });
  //     return e.message;
  //   } catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return showAlert(context, "Error",
  //               "Email might already exist or an internal server occurred, please try again!");
  //         });
  //     return 'Registration failed: $e';
  //   }
  // }

  Future<String?> login({
    required String email,
    required String password,
    context,
  }) async {
    try {
      // Check internet
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('📶 Connected to internet');
        }
      } on SocketException catch (_) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return showAlert(context, "Error", "No internet connection");
          },
        );
      }

      _isLoading = true;
      notifyListeners();

      print('🔐 Logging in: $email');

      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _isLoading = false;
        notifyListeners();
        return 'Login failed';
      }

      print('✅ Login successful: ${response.user!.email}');

      // Load profile from server
      await _loadUserProfileFromServer(response.user!.id);

      _isLoading = false;
      notifyListeners();

      if (_currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return null;
      } else {
        return 'Failed to load user profile';
      }
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showAlert(context, "Error", e.message);
        },
      );
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showAlert(context, "Error", "Please try again");
        },
      );
      return 'Login failed: $e';
    }
  }

  Future<void> _loadUserProfileFromServer(String userId) async {
    try {
      print('📥 Loading profile from server: $userId');

      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();

      _currentUser = UserModel.fromJson(response);

      // Save to local storage for offline access
      await SessionManager.saveSession(
        userId: userId,
        email: _currentUser!.email,
        user: _currentUser!,
      );

      print('✅ Profile loaded and saved locally: ${_currentUser!.email}');
      notifyListeners();
    } catch (e) {
      print('❌ Error loading profile from server: $e');

      // Try to load from local cache as fallback
      final localUser = await SessionManager.getUserData();
      if (localUser != null) {
        _currentUser = localUser;
        print('📱 Using cached profile');
        notifyListeners();
      }
    }
  }

  Future<String?> updateProfile({
    String? firstName,
    String? middleName,
    String? lastName,
    String? contactNo,
    List<String>? allergies,
  }) async {
    if (_currentUser == null) return 'Not logged in';

    try {
      _isLoading = true;
      notifyListeners();

      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (middleName != null) updates['middle_name'] = middleName;
      if (lastName != null) updates['last_name'] = lastName;
      if (contactNo != null) updates['contact_no'] = contactNo;
      if (allergies != null) updates['allergies'] = allergies;

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', _currentUser!.id);

      // Reload profile
      await _loadUserProfileFromServer(_currentUser!.id);

      _isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      print('❌ Update error: $e');

      // Update local cache even if server update fails
      if (allergies != null && _currentUser != null) {
        _currentUser = _currentUser!.copyWith(allergies: allergies);
        await SessionManager.updateUserData(_currentUser!);
        notifyListeners();
      }

      _isLoading = false;
      notifyListeners();
      return 'Update saved locally. Will sync when online.';
    }
  }

  Future<void> logout(context) async {
    try {
      await _supabase.auth.signOut();
      await SessionManager.clearSession();
      _currentUser = null;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      notifyListeners();
    } catch (e) {
      print("Error logging out: $e");

      // Clear local data even if sign out fails
      await SessionManager.clearSession();
      _currentUser = null;
      notifyListeners();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }
}

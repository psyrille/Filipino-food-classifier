import 'dart:io';

import 'package:filipino_food_scanner/screens/home_screen.dart';
import 'package:filipino_food_scanner/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo:
            'io.supabase.bantayallerji://reset-password', // Your app's deep link
      );

      _isLoading = false;
      notifyListeners();
      return null; // Success
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();

      // Handle specific Supabase auth errors
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
      return null; // Success
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
    try {
      final session = _supabase.auth.currentSession;

      if (session != null) {
        print('✅ Session found! User: ${session.user.email}');
        print('🕐 Expires at: ${session.expiresAt}');

        // Load user profile
        await _loadUserProfile(session.user.id);
      } else {
        print('ℹ️ No active session found');
      }

      _supabase.auth.onAuthStateChange.listen((data) {
        final event = data.event;
        print('🔔 Auth event: $event');

        if (event == AuthChangeEvent.signedIn) {
          print('✅ User signed in');
          if (data.session?.user != null) {
            _loadUserProfile(data.session!.user.id);
          }
        } else if (event == AuthChangeEvent.signedOut) {
          print('👋 User signed out');
          _currentUser = null;
          notifyListeners();
        } else if (event == AuthChangeEvent.tokenRefreshed) {
          print('🔄 Token refreshed');
        }
      });
    } catch (e) {
      print('❌ Error initializing auth: $e');
    }
  }

  // Register new user
  Future<String?> register({
    context,
    required String email,
    required String password,
    required String firstName,
    String? middleName,
    required String lastName,
    String? contactNo,
    required List<String> allergies,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('📝 Registering user: $email');

      // Create auth user
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _isLoading = false;
        notifyListeners();
        return 'Failed to create account';
      }

      print('✅ Auth user created: ${response.user!.id}');

      // Create user profile
      await _supabase.from('profiles').upsert({
        'id': response.user!.id,
        'email': email,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'contact_no': contactNo,
        'allergies': allergies,
      });

      print('✅ Profile created');

      // Load user profile
      await _loadUserProfile(response.user!.id);

      _isLoading = false;
      notifyListeners();

      return null; // Success
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return showAlert(context, "Error", e.message);
          });
      print('❌ Auth error: ${e.message}');
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return showAlert(context, "Error",
                "Email might already exist or an internal server occurred, please try again!");
          });
      print('❌ Registration error: $e');
      return 'Registration failed: $e';
    }
  }

  // Login user
  Future<String?> login(
      {required String email, required String password, context}) async {
    try {
      // Check for internet connectivity
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
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

      // Attempt to sign in with the provided credentials
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // If no user is returned, the login failed
      if (response.user == null) {
        _isLoading = false;
        notifyListeners();
        return 'Login failed';
      }

      final session = _supabase.auth.currentSession;

      if (session != null && session.accessToken.isNotEmpty) {
        await _loadUserProfile(response.user!.id);

        _isLoading = false;
        notifyListeners();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );

        return null;
      } else {
        // Handle invalid session
        _isLoading = false;
        notifyListeners();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return showAlert(
                context, "Error", "Session is not valid. Please log in again.");
          },
        );
        return 'Session error';
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

  Future<void> storeSession(AuthResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    // Store the session token, user ID, or any other necessary data
    await prefs.setString('access_token', response.session?.accessToken ?? '');
    await prefs.setString('user_id', response.user?.id ?? '');
    await prefs.setBool('is_logged_in', true); // Mark as logged in
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final response =
          await _supabase.from('profiles').select().eq('id', userId).single();

      _currentUser = UserModel.fromJson(response);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Update user profile
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

      await _loadUserProfile(_currentUser!.id);

      _isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Update failed: $e';
    }
  }

  // Logout
  Future<void> logout(context) async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      notifyListeners();
    } catch (e) {
      print("Error ${e}");
    }
  }

  // // Reset password
  // Future<String?> resetPassword(String email) async {
  //   try {
  //     await _supabase.auth.resetPasswordForEmail(email);
  //     return null; // Success
  //   } on AuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return 'Password reset failed: $e';
  //   }
  // }
}

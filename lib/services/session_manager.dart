import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class SessionManager {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserData = 'user_data';
  static const String _keySessionTimestamp = 'session_timestamp';

  // Store session locally
  static Future<bool> saveSession({
    required String userId,
    required String email,
    required UserModel user,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final success = await Future.wait([
        prefs.setString(_keyUserId, userId),
        prefs.setString(_keyUserEmail, email),
        prefs.setString(_keyUserData, jsonEncode(user.toJson())),
        prefs.setBool(_keyIsLoggedIn, true),
        prefs.setInt(
            _keySessionTimestamp, DateTime.now().millisecondsSinceEpoch),
      ]).then((_) => true).catchError((_) => false);

      if (success) {
        print('✅ Session saved locally: $email');
      } else {
        print('❌ Failed to save session');
      }

      return success;
    } catch (e) {
      print('❌ Error saving session: $e');
      return false;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

      if (!isLoggedIn) {
        print('ℹ️ No local session found');
        return false;
      }

      // Check if session is expired (30 days)
      final timestamp = prefs.getInt(_keySessionTimestamp);
      if (timestamp == null) {
        print('⚠️ Session timestamp missing');
        return false;
      }

      final sessionAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final maxAge = Duration(days: 30).inMilliseconds;

      if (sessionAge > maxAge) {
        print(
            '⚠️ Session expired (${Duration(milliseconds: sessionAge).inDays} days old)');
        await clearSession();
        return false;
      }

      print(
          '✅ Valid local session found (${Duration(milliseconds: sessionAge).inDays} days old)');
      return true;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Get stored user ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserId);
    } catch (e) {
      print('❌ Error getting user ID: $e');
      return null;
    }
  }

  // Get stored user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserEmail);
    } catch (e) {
      print('❌ Error getting user email: $e');
      return null;
    }
  }

  // Get stored user data
  static Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_keyUserData);

      if (userDataString == null) {
        print('⚠️ No user data found');
        return null;
      }

      final userJson = jsonDecode(userDataString);
      final user = UserModel.fromJson(userJson);

      print('✅ User data retrieved: ${user.email}');
      return user;
    } catch (e) {
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Clear session
  static Future<bool> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await Future.wait([
        prefs.remove(_keyUserId),
        prefs.remove(_keyUserEmail),
        prefs.remove(_keyUserData),
        prefs.remove(_keyIsLoggedIn),
        prefs.remove(_keySessionTimestamp),
      ]);

      print('🗑️ Session cleared');
      return true;
    } catch (e) {
      print('❌ Error clearing session: $e');
      return false;
    }
  }

  // Update user data only (keep session active)
  static Future<bool> updateUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
      print('✅ User data updated locally');
      return true;
    } catch (e) {
      print('❌ Error updating user data: $e');
      return false;
    }
  }

  // Refresh session timestamp (extend session)
  static Future<bool> refreshSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          _keySessionTimestamp, DateTime.now().millisecondsSinceEpoch);
      print('🔄 Session timestamp refreshed');
      return true;
    } catch (e) {
      print('❌ Error refreshing session: $e');
      return false;
    }
  }

  // Debug: Print all session data
  static Future<void> debugPrintSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('📊 Session Debug Info:');
      print('   - Is Logged In: ${prefs.getBool(_keyIsLoggedIn)}');
      print('   - User ID: ${prefs.getString(_keyUserId)}');
      print('   - User Email: ${prefs.getString(_keyUserEmail)}');
      print('   - Has User Data: ${prefs.getString(_keyUserData) != null}');
      print('   - Timestamp: ${prefs.getInt(_keySessionTimestamp)}');
    } catch (e) {
      print('❌ Error debugging session: $e');
    }
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'username';

  // Hardcoded valid credentials:
  // 1) admin / admin
  // 2) 124240180 / 124240180 (or admin)
  // 3) potter / gryffindor
  static const Map<String, String> _validUsers = {
    'admin': 'admin',
    '124240180': '124240180',
    'potter': 'gryffindor',
  };

  /// Validates credentials against hardcoded user store
  static bool validateCredentials(String username, String password) {
    final trimmedUsername = username.trim();

    // Student NIM can use either NIM or admin as password
    if (trimmedUsername == '124240180') {
      return password == '124240180' || password == 'admin';
    }

    if (_validUsers.containsKey(trimmedUsername)) {
      return _validUsers[trimmedUsername] == password;
    }

    return false;
  }

  /// Saves login session to SharedPreferences
  static Future<void> saveLoginSession(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
  }

  /// Checks if user is currently logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Retrieves the stored username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  /// Clears login session on logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUsername);
  }
}

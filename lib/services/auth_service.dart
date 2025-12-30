import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _phoneKey = 'phone_number';

  static Future<bool> login(String phone, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (phone == '9876543210' && password == 'driver123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, 'demo_token_123');
      await prefs.setString(_phoneKey, phone);
      return true;
    }
    return false;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_phoneKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}

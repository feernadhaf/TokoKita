import 'package:shared_preferences/shared_preferences.dart';

class SessionServices {
  static Future<void> login(String username, [String? email]) async {
    // Implement login functionality
    final prefs = await SharedPreferences.getInstance();
    //mengatur status login menjadi true
    await prefs.setBool('isLoggedIn', true);
    //kalo isLoggedIn true, maka akan diarahkan ke halaman home dan dipakai nanti untuk menentukan apakah user sudah login atau belum
    await prefs.setString('username', username);
    // Simpen email juga (dari akun yang beneran login lewat AuthServices).
    if (email != null) {
      await prefs.setString('email', email);
    }
  }

  //cek apakah user sudah login atau belum
  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  //ambil username dari shared preferences
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  //ambil email dari shared preferences
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  //logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');
    await prefs.remove('email');
  }
}
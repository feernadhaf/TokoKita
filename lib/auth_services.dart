import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// =========================
// AUTH SERVICES (lokal, tanpa backend)
// Nyimpen daftar akun yang pernah daftar di HP ini lewat shared_preferences,
// dan ngecek email+password beneran pas login (bukan cuma cek format).
//
// PENTING: password di sini disimpen POLOS (plain text) di local storage
// device. Ini cukup buat demo/belajar, TAPI JANGAN dipakai kayak gini di
// app production sungguhan — untuk production, autentikasi & penyimpanan
// password harus lewat backend/server asli dengan password yang di-hash,
// bukan disimpan apa adanya di HP user.
// =========================

class AuthResult {
  final bool success;
  final String? errorMessage;
  final Map<String, String>? user;

  AuthResult.success(this.user)
      : success = true,
        errorMessage = null;

  AuthResult.failure(this.errorMessage)
      : success = false,
        user = null;
}

class AuthServices {
  static const _usersKey = 'registered_users';

  static Future<List<Map<String, String>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  static Future<void> _saveUsers(List<Map<String, String>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  // =========================
  // Daftar akun baru
  // =========================
  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final emailLower = email.trim().toLowerCase();

    final alreadyExists = users.any((u) => u['email'] == emailLower);
    if (alreadyExists) {
      return AuthResult.failure('Email ini udah terdaftar, coba login aja.');
    }

    users.add({
      'name': name.trim(),
      'email': emailLower,
      'password': password,
    });

    await _saveUsers(users);
    return AuthResult.success({'name': name.trim(), 'email': emailLower});
  }

  // =========================
  // Login — ngecek email & password ke daftar akun yang pernah daftar
  // =========================
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final emailLower = email.trim().toLowerCase();

    final found = users.where((u) => u['email'] == emailLower).toList();
    if (found.isEmpty) {
      return AuthResult.failure(
        'Email belum terdaftar. Daftar dulu, yuk.',
      );
    }

    final user = found.first;
    if (user['password'] != password) {
      return AuthResult.failure('Password salah. Coba lagi.');
    }

    return AuthResult.success(user);
  }
}
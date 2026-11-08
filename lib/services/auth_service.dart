import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'local_users';

  // 1. Fungsi Register (Simpan akun ke memori HP)
  Future register({
    required String nik,
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulasi loading
    final prefs = await SharedPreferences.getInstance();

    final String? usersJson = prefs.getString(_usersKey);
    List<dynamic> users = usersJson != null ? jsonDecode(usersJson) : [];

    // Cek apakah NIK atau Email sudah terdaftar
    bool exists = users.any((u) => u['email'] == email || u['nik'] == nik);
    if (exists) {
      return {'success': false, 'message': 'NIK atau Email sudah terdaftar!'};
    }

    users.add({
      'nik': nik,
      'name': name,
      'email': email,
      'password': password,
      'role': 'warga', // Default pendaftar baru adalah Warga
    });

    await prefs.setString(_usersKey, jsonEncode(users));
    return {'success': true, 'message': 'Registrasi berhasil! Silakan masuk.'};
  }

  // 2. Fungsi Login (Cek akun di memori HP + akun default)
  Future login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulasi loading
    final prefs = await SharedPreferences.getInstance();

    // Akun bawaan untuk tes cepat Admin Desa
    if (identifier == 'admin@apel.id' && password == 'admin123') {
      await prefs.setString('token', 'mock_token_admin');
      await prefs.setString('role', 'admin');
      return {'success': true, 'role': 'admin', 'message': 'Login Admin berhasil'};
    }

    // Akun bawaan untuk tes cepat Warga
    if (identifier == 'warga@apel.id' && password == 'warga123') {
      await prefs.setString('token', 'mock_token_warga');
      await prefs.setString('role', 'warga');
      return {'success': true, 'role': 'warga', 'message': 'Login Warga berhasil'};
    }

    // Cek akun yang baru dibuat lewat halaman Register
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      List<dynamic> users = jsonDecode(usersJson);
      for (var user in users) {
        if ((user['email'] == identifier || user['nik'] == identifier) &&
            user['password'] == password) {
          await prefs.setString('token', 'mock_token_${user['nik']}');
          await prefs.setString('role', user['role'] ?? 'warga');
          return {
            'success': true,
            'role': user['role'] ?? 'warga',
            'message': 'Login berhasil',
          };
        }
      }
    }

    return {'success': false, 'message': 'NIK/Email atau Kata Sandi salah!'};
  }
}
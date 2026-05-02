import 'package:flutter/material.dart';
import '../models/user_model.dart';
// import '../services/api_client.dart'; // Nanti diaktifkan kalau sudah konek API

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Fungsi Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // --- SIMULASI API CALL ---
      // Nantinya kamu ganti dengan: await _apiClient.post('/login', ...)
      await Future.delayed(const Duration(seconds: 2));

      if (email == "john@example.com" && password == "password123") {
        _user = UserModel(
          id: "USR-001", // ID unik untuk John
          name: "John Doe",
          email: email,
          phone: "08123456789",
          avatarUrl: "https://ui-avatars.com/api/?name=John+Doe", // Avatar otomatis dari nama
          walletBalance: 50000,
          points: 100,
        );

        _setLoading(false);
        return true;
      } else {
        _errorMessage = "Email atau password salah!";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = "Terjadi kesalahan jaringan.";
      _setLoading(false);
      return false;
    }
  }

  // Fungsi Register
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);

    try {
      // Simulasi delay daftar
      await Future.delayed(const Duration(seconds: 2));

      // Logika simpan ke database (simulasi)
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Fungsi Logout
  void logout() {
    _user = null;
    notifyListeners();
  }

  // Helper untuk set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

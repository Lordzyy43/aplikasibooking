import 'package:flutter/material.dart';
import 'package:apkbooking/models/user_model.dart';
// import 'package:apkbooking/services/api_client.dart'; // Aktifkan nanti kalau sudah konek API

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  /// Login dummy.
  /// Untuk sementara, semua email dan password dianggap berhasil.
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final cleanEmail = email.trim();

      _user = UserModel(
        id: _generateDummyUserId(),
        name: _getNameFromEmail(cleanEmail),
        email: cleanEmail.isNotEmpty ? cleanEmail : 'user@example.com',
        phone: '08123456789',
        avatarUrl: 'assets/Avatar/Avatar.png',
        walletBalance: 50000,
        points: 100,
      );

      return true;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat login.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Register dummy.
  /// Setelah register berhasil, user langsung dianggap login.
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _user = UserModel(
        id: _generateDummyUserId(),
        name: name.trim().isNotEmpty ? name.trim() : 'User Aerobook',
        email: email.trim().isNotEmpty ? email.trim() : 'user@example.com',
        phone: phone.trim().isNotEmpty ? phone.trim() : '08123456789',
        avatarUrl: 'assets/Avatar/Avatar.png',
        walletBalance: 0,
        points: 0,
      );

      return true;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat register.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update profile dummy.
  /// Berguna kalau nanti ada halaman edit profil.
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (_user == null) {
      _errorMessage = 'User belum login.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      _user = UserModel(
        id: _user!.id,
        name: name.trim().isNotEmpty ? name.trim() : _user!.name,
        email: email.trim().isNotEmpty ? email.trim() : _user!.email,
        phone: phone.trim().isNotEmpty ? phone.trim() : _user!.phone,
        avatarUrl: _user!.avatarUrl,
        walletBalance: _user!.walletBalance,
        points: _user!.points,
      );

      return true;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat update profil.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user.
  void logout() {
    _user = null;
    _clearError();
    notifyListeners();
  }

  /// Hapus pesan error secara manual.
  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  String _generateDummyUserId() {
    return 'USR-${DateTime.now().millisecondsSinceEpoch}';
  }

  String _getNameFromEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return 'User Aerobook';
    }

    final username = email.split('@').first;

    if (username.isEmpty) {
      return 'User Aerobook';
    }

    return username
        .split(RegExp(r'[._-]'))
        .where((part) => part.isNotEmpty)
        .map((part) {
          return part[0].toUpperCase() + part.substring(1).toLowerCase();
        })
        .join(' ');
  }
}

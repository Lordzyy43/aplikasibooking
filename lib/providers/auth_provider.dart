import 'package:flutter/material.dart';
import 'package:apkbooking/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _hydrateSession();
  }

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  SupabaseClient get _client => Supabase.instance.client;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final cleanEmail = email.trim();
      final response = await _client.auth.signInWithPassword(
        email: cleanEmail,
        password: password,
      );

      if (response.user == null) {
        _errorMessage = 'Akun tidak ditemukan atau password salah.';
        return false;
      }

      _user = await _userFromSupabase(response.user!);

      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat login.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final cleanName = name.trim().isNotEmpty ? name.trim() : 'User Aerobook';
      final cleanEmail = email.trim();
      final cleanPhone = phone.trim();

      final response = await _client.auth.signUp(
        email: cleanEmail,
        password: password,
        data: {'full_name': cleanName, 'phone': cleanPhone, 'role': 'customer'},
      );

      if (response.user == null) {
        _errorMessage = 'Registrasi belum berhasil. Coba lagi.';
        return false;
      }

      _user = await _userFromSupabase(response.user!);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
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
      await _client
          .from('users')
          .update({
            'full_name': name.trim().isNotEmpty ? name.trim() : _user!.name,
            'phone': phone.trim().isNotEmpty ? phone.trim() : _user!.phone,
          })
          .eq('id', _user!.id);

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
    } on PostgrestException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Terjadi kesalahan saat update profil.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
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

  Future<void> _hydrateSession() async {
    final sessionUser = _client.auth.currentUser;
    if (sessionUser == null) return;

    try {
      _user = await _userFromSupabase(sessionUser);
      notifyListeners();
    } catch (_) {
      _user = null;
      notifyListeners();
    }
  }

  Future<UserModel> _userFromSupabase(User authUser) async {
    Map<String, dynamic>? profile;

    try {
      profile = await _client.rpc('ensure_customer_user').maybeSingle();
    } catch (_) {
      try {
        profile = await _client
            .from('users')
            .select('full_name, phone, avatar_url, wallet_balance, points')
            .eq('id', authUser.id)
            .maybeSingle();
      } catch (_) {
        profile = null;
      }
    }

    final metadata = authUser.userMetadata ?? const <String, dynamic>{};
    final email = authUser.email ?? '';
    final name =
        profile?['full_name']?.toString() ??
        metadata['full_name']?.toString() ??
        _getNameFromEmail(email);

    return UserModel(
      id: authUser.id,
      name: name,
      email: email,
      phone: profile?['phone']?.toString() ?? metadata['phone']?.toString(),
      avatarUrl:
          profile?['avatar_url']?.toString() ?? 'assets/Avatar/Avatar.png',
      walletBalance:
          int.tryParse(profile?['wallet_balance']?.toString() ?? '') ?? 0,
      points: int.tryParse(profile?['points']?.toString() ?? '') ?? 0,
    );
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

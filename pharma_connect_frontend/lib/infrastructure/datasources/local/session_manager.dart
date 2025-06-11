import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionManager {
  static const String _pharmacyIdKey = 'pharmacy_id';
  static const String _userIdKey = 'user_id';
  static const String _tokenKey = 'token';

  final SharedPreferences _prefs;

  SessionManager(this._prefs);

  Future<void> savePharmacyId(String? pharmacyId) async {
    if (pharmacyId != null && pharmacyId.isNotEmpty) {
      await _prefs.setString(_pharmacyIdKey, pharmacyId);
    }
  }

  String? getPharmacyId() {
    return _prefs.getString(_pharmacyIdKey);
  }

  Future<void> saveUserId(String userId) async {
    if (userId.isNotEmpty) {
      await _prefs.setString(_userIdKey, userId);
    }
  }

  String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  Future<void> saveToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      await _prefs.setString(_tokenKey, token);
    }
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_pharmacyIdKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_tokenKey);
  }
}

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final sessionManagerProvider = Provider<SessionManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SessionManager(prefs);
});

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String autoLoginKey = 'auto_login_enabled';
  static const String onboardingDoneKey = 'onboarding_done';
  static const String lastLoginEmailKey = 'last_login_email';
  static const String notificationPromptedKey = 'notification_prompted';

  final FlutterSecureStorage _secureStorage;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: accessTokenKey, value: accessToken);
    await _secureStorage.write(key: refreshTokenKey, value: refreshToken);
  }

  Future<String?> readAccessToken() {
    return _secureStorage.read(key: accessTokenKey);
  }

  Future<String?> readRefreshToken() {
    return _secureStorage.read(key: refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: accessTokenKey);
    await _secureStorage.delete(key: refreshTokenKey);
  }

  Future<void> setAutoLoginEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(autoLoginKey, enabled);
  }

  Future<bool> isAutoLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(autoLoginKey) ?? false;
  }

  Future<void> setOnboardingDone(bool done) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingDoneKey, done);
  }

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingDoneKey) ?? false;
  }

  Future<void> setLastLoginEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastLoginEmailKey, email);
  }

  Future<String?> getLastLoginEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastLoginEmailKey);
  }

  Future<void> setNotificationPrompted(bool prompted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationPromptedKey, prompted);
  }

  Future<bool> isNotificationPrompted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationPromptedKey) ?? false;
  }
}

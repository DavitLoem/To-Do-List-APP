import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // បង្កើត instance នៃ FlutterSecureStorage
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // កំណត់ Keys ជា Private Constants ការពារកុំឱ្យក្រុមការងារសរសេរខុសអក្ខរាវិរុទ្ធ (Typo) ពេលហៅប្រើ
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserRole = 'user_role';

  /// រក្សាទុក Token ទាំងពីរចូលទៅក្នុង Secure Storage (ប្រើពេល Login ជោគជ័យ)
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String role,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyUserRole, value: role);
  }

  /// ទាញយក Access Token មកប្រើ (សម្រាប់ដាក់ក្នុង API Header)
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// ទាញយក Refresh Token មកប្រើ (សម្រាប់ហៅ API សុំ Access Token ថ្មី)
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  /// លុប Token ទាំងអស់ចោល (ប្រើនៅពេល Logout ឬពេល Refresh Token ផុតកំណត់ដែរ)
  static Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserRole);
  }
}

import 'package:dio/dio.dart';
import 'package:to_do_list/core/api/network/api_client.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';

class AuthServices {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> signUp({
    required String fullname,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return _apiClient.post(
      '/auth/register',
      data: {
        'fullname': fullname,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );
  }

  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final accessToken = response['access_token']?.toString();
    final refreshToken = response['refresh_token']?.toString();
    final role =
        response['role']?.toString() ??
        await TokenStorage.getUserRole() ??
        'seeker';

    if (accessToken != null && accessToken.isNotEmpty) {
      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        role: role,
      );
    }

    return response;
  }

  Future<dynamic> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return _apiClient.post(
      '/auth/change-password',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }

  Future<dynamic> forgotPassword({required String email}) async {
    return _apiClient.post('/auth/forgot-password', data: {'email': email});
  }

  Future<dynamic> verifyOTP({
    required String email,
    required String otp,
  }) async {
    return _apiClient.post(
      '/auth/verify-otp',
      data: {'email': email, 'otp': otp},
    );
  }

  Future<dynamic> getProfile() async {
    return _apiClient.get('/auth/me');
  }

  Future<dynamic> updateProfile({
    required String fullname,
    required String email,
  }) async {
    return _apiClient.put(
      '/auth/me',
      data: {'fullname': fullname, 'email': email},
    );
  }

  Future<dynamic> logout() async {
    return _apiClient.post('/auth/logout');
  }

  Future<dynamic> uploadProfileImage(String imagePath) async {
    final formData = FormData.fromMap({
      // Change 'image' back to 'file' to match the backend requirement
      'file': await MultipartFile.fromFile(imagePath),
    });
    return _apiClient.post('/auth/upload-profile-image', data: formData);
  }
}

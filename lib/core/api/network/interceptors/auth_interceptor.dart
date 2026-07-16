import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';
import 'package:to_do_list/routes/app_page.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  // ១. ដំណើរការមុនពេល Request ត្រូវបានបញ្ជូនទៅកាន់ Server
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 1. Try to refresh the token if it's a 401
      try {
        final refreshToken = await TokenStorage.getRefreshToken();
        if (refreshToken == null) {
          _performLogout();
          return handler.reject(err);
        }

        // Call your refresh API here
        final response = await dio.post(
          '/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken = response.data['access_token'];
        await TokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: response.data['refresh_token'] ?? refreshToken,
          role: await TokenStorage.getUserRole() ?? 'seeker',
        );

        // Retry the original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final cloneRequest = await dio.fetch(err.requestOptions);
        return handler.resolve(cloneRequest);
      } catch (e) {
        debugPrint("❌ Refresh failed: $e");
        _performLogout();
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }

  void _performLogout() {
    // Logic to clear storage and navigate to Login
    Get.offAllNamed(AppRoutes.signIn);
  }
}

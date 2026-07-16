import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:to_do_list/core/api/network/interceptors/auth_interceptor.dart';

import '../../config/api_config.dart';

class DioClient {
  // ការបង្កើត Singleton Pattern
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  // Factory constructor តែងតែបោះតម្លៃ instance ដដែលត្រឡប់មកវិញ
  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: ApiConfig.connectionTimeout),
        receiveTimeout: const Duration(seconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // AuthInterceptor must always be attached so authenticated requests and
    // 401 token-refresh work in release/profile builds too (not just debug).
    dio.interceptors.add(AuthInterceptor(dio));

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody:
              true, // បើចង់លាក់ Password សូម្បីតែពេល Dev អាចប្តូរទៅ false
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }
}

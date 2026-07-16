import 'package:dio/dio.dart';
import 'package:to_do_list/core/api/network/api_exception.dart';
import 'package:to_do_list/core/api/network/interceptors/dio_client.dart';



class ApiClient {
  // ទាញយក Single Instance របស់ DioClient មកប្រើ
  final Dio _dio = DioClient().dio;

  // --- GET ---
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- POST ---
  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PUT ---
  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- PATCH ---
  Future<dynamic> patch(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.patch(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- DELETE ---
  Future<dynamic> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ប្រព័ន្ធចាប់ Error រួម (Centralized Error Handler)
  // ==========================================
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException(
            "Internet connection is slow or disconnected. Please try again.",
          );

        case DioExceptionType.connectionError:
          return ApiException(
            "No internet connection. Please check your WiFi or mobile data.",
          );

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;

          // 🎯 ចំណុចសំខាន់: ចាប់យកសារដែល Backend បោះមកតាមរយៈ key "detail" ឬ "message"
          final data = error.response?.data;
          String serverMessage = "Server error (code: $statusCode)";

          if (data is Map<String, dynamic>) {
            // 🎯 ១. ឆែកមើលទម្រង់ថ្មី (key: 'errors')
            if (data['errors'] != null && data['errors'] is List) {
              serverMessage = (data['errors'] as List)
                  .map((e) => e['message'].toString()) // ទាញយក key 'message'
                  .join('\n');
            }
            // ២. ឆែកមើលទម្រង់ចាស់ (key: 'detail')
            else if (data['detail'] != null) {
              var detailData = data['detail'];
              if (detailData is String) {
                serverMessage = detailData;
              } else if (detailData is List) {
                serverMessage = detailData
                    .map((e) => e['msg'].toString()) // ទាញយក key 'msg'
                    .join('\n');
              }
            }
            // ៣. ឆែកមើល key 'message' ខាងក្រៅ
            else if (data['message'] != null) {
              serverMessage = data['message'].toString();
            }
          }

          if (statusCode == 404) {
            // ឆែកមើលថាតើ Backend ពិតជាបានភ្ជាប់សារអ្វីមួយមកជាមួយដែរឬទេ?
            bool hasServerMessage =
                data != null &&
                (data['detail'] != null ||
                    data['message'] != null ||
                    data['errors'] != null);

            // បើមានសារពី Backend (ឧ. "Email not found") យកវាមកបង្ហាញ។
            // បើអត់ទេ បង្ហាញសារ Professional ជាភាសាអង់គ្លេសទូទៅ
            return ApiException(
              hasServerMessage
                  ? serverMessage
                  : "We couldn't find the requested information.",
              statusCode: statusCode,
            );
          } else if (statusCode == 500) {
            return ApiException(
              "Server is currently experiencing issues (500). Please wait a moment.",
              statusCode: statusCode,
            );
          }

          // សម្រាប់ Error ផ្សេងៗទៀត (ដូចជា 400, 401, 403, 429) យើងយកសារពី Backend មកបង្ហាញតែម្តង
          return ApiException(serverMessage, statusCode: statusCode);

        case DioExceptionType.cancel:
          return ApiException("Operation was cancelled.");

        default:
          return ApiException("An unknown error occurred.");
      }
    } else {
      // ករណី Error កើតចេញពីកូដ Flutter ផ្ទាល់ (មិនមែនមកពី API)
      return ApiException("System error: ${error.toString()}");
    }
  }
}

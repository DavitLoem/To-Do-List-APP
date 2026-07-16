import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8000';
  static const int connectionTimeout = 10;
  static const int receiveTimeout = 10;
}

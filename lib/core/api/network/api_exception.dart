// ថ្នាក់នេះប្រើសម្រាប់ខ្ចប់សារ Error ដែលយើងបានបកប្រែរួចរាល់
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

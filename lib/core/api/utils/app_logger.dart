import 'package:logger/logger.dart';

class AppLogger {
  // បង្កើត Instance តែមួយគត់ជាមួយការកំណត់រចនាបថ (PrettyPrinter)
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // មិនបាច់បង្ហាញកូដហៅពីណាទេ ដើម្បីកុំឱ្យរញ៉េរញ៉ៃ Console
      errorMethodCount:
          5, // តែបើមាន Error ធ្ងន់, បង្ហាញ 5 បន្ទាត់ដើម្បីងាយស្រួលតាមដាន (Stacktrace)
      lineLength: 80, // ប្រវែងបន្ទាត់
      colors: true, // បើកពណ៌
      printEmojis: true, // បើក Emoji ឱ្យងាយស្រួលចំណាំ
      dateTimeFormat: DateTimeFormat.none, // មិនបង្ហាញម៉ោង
    ),
  );

  // 1. Debug 🐛 (ពណ៌ប្រផេះ/ខៀវ) -> សម្រាប់ Print មើលលទ្ធផលទូទៅពេលកំពុងសរសេរកូដ
  static void d(dynamic message) => _logger.d(message);

  // 2. Info 💡 (ពណ៌ខៀវចាស់) -> សម្រាប់ផ្តល់ដំណឹងថាមានសកម្មភាពអ្វីមួយបានចាប់ផ្តើម ឬជោគជ័យ
  static void i(dynamic message) => _logger.i(message);

  // 3. Warning ⚠️ (ពណ៌លឿង) -> សម្រាប់កំហុសតូចតាចដែលយើងដឹងមុន (ឧទាហរណ៍: អ្នកប្រើវាយ Password ខុស)
  static void w(dynamic message) => _logger.w(message);

  // 4. Error 🛑 (ពណ៌ក្រហមឆ្អៅ) -> សម្រាប់កំហុសធ្ងន់ធ្ងរ ឬកំហុសប្រព័ន្ធ (App Crash)
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

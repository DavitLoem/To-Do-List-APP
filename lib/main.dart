import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Added for env support
import 'package:to_do_list/core/theme/app_theme.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/routes/app_routes.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // FIX: Initialize DotEnv before running the app
  await dotenv.load(fileName: "assets/.env");

  // Read the saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final initialThemeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

  runApp(MyApp(initialThemeMode: initialThemeMode));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}

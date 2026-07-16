import 'package:to_do_list/screens/auth/forgot_password/forgot_password_view.dart';
import 'package:to_do_list/screens/auth/sign_in_screen/sign_in_screen_view.dart';
import 'package:to_do_list/screens/auth/sign_up_screen/sign_up_screen_view.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:get/get.dart';
import 'package:to_do_list/screens/auth/verify_otp_screen/verify_otp_screen_view.dart';
import 'package:to_do_list/screens/splash/splash_binding.dart';
import 'package:to_do_list/screens/splash/splash_view.dart';
import 'package:to_do_list/screens/tasks/add_task/add_task_view.dart';
import 'package:to_do_list/screens/tasks/calendar/calendar_binding.dart';
import 'package:to_do_list/screens/tasks/calendar/calendar_view.dart';
import 'package:to_do_list/screens/tasks/dashboard_screen/dashboard_screen_binding.dart';
import 'package:to_do_list/screens/tasks/dashboard_screen/dashboard_screen_view.dart';
import 'package:to_do_list/screens/tasks/detail_task/detail_task_view.dart';
import 'package:to_do_list/screens/tasks/my_task/my_task_binding.dart';
import 'package:to_do_list/screens/tasks/my_task/my_task_controller.dart';
import 'package:to_do_list/screens/tasks/my_task/my_task_view.dart';
import 'package:to_do_list/screens/tasks/setting/setting_binding.dart';
import 'package:to_do_list/screens/tasks/setting/setting_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => SignInScreenView(),
      binding: SignInScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignUpScreenView(),
      binding: SignUpScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordViewBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => VerifyOtpScreenView(),
      binding: VerifyOtpScreenViewBinding(),
    ),
    GetPage(
      name: AppRoutes.myTask,
      page: () => MyTaskView(),
      binding: MyTaskBinding(),
    ),
    GetPage(
      name: AppRoutes.addTask,
      page: () => AddTaskView(),
      binding: AddTaskViewBinding(),
    ),
    GetPage(
      name: AppRoutes.detailTask,
      page: () => DetailTaskView(),
      binding: DetailTaskViewBinding(),
    ),

    GetPage(
      name: AppRoutes.dasboard,
      page: () => const DashboardScreenView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.calendar,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
  ];
}

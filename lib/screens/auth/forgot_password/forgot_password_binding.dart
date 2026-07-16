part of 'forgot_password_view.dart';

class ForgotPasswordViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordViewController());
  }
}
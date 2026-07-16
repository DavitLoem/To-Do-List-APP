part of 'verify_otp_screen_view.dart';

class VerifyOtpScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyOtpScreenViewController());
  }
}
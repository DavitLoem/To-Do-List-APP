import 'dart:async';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/routes/app_page.dart';

class VerifyOtpScreenViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  late String email;
  final RxBool isLoading = false.obs;

  final RxInt timerSeconds = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Retrieve email passed from Forgot Password screen.
    // Replace with a default if testing directly.
    email = Get.arguments ?? 'bryant.24@gmail.com';
    startTimer();
  }

  // --- NEW: Helper to mask the email ---
  String get maskedEmail {
    if (!email.contains('@')) return email; // Safety check

    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];

    // If the name is very short, just show the first letter
    if (name.length <= 3) {
      return '${name[0]}***@$domain';
    }

    // Keep the first 2 and last 2 characters, mask the rest
    final firstTwo = name.substring(0, 2);
    final lastTwo = name.substring(name.length - 2);
    final stars = '*' * (name.length - 4);

    return '$firstTwo$stars$lastTwo@$domain';
  }

  void startTimer() {
    timerSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length < 4) {
      Get.snackbar('Error', 'Please enter a complete 4-digit OTP');
      return;
    }

    try {
      isLoading.value = true;
      await _authServices.verifyOTP(email: email, otp: otp);
      Get.toNamed(AppRoutes.signIn);
      Get.snackbar('Success', 'OTP Verified successfully');

      // TODO: Navigate to Create New Password Screen
      // Get.toNamed(AppRoutes.createNewPassword);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() async {
    if (timerSeconds.value > 0) return; // Prevent spamming

    try {
      await _authServices.forgotPassword(email: email);
      Get.snackbar('Success', 'A new OTP has been sent');
      startTimer(); // Restart the countdown
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

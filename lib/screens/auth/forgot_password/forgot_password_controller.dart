part of 'forgot_password_view.dart';

class ForgotPasswordViewController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final RxBool isLoading = false.obs;

  Future<void> sendResetLink(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address');
      return;
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    try {
      isLoading.value = true;
      await _authServices.forgotPassword(email: trimmedEmail);
      Get.toNamed(AppRoutes.verifyOtp, arguments: trimmedEmail);
      Get.snackbar('Success', 'Password reset link sent to your email');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

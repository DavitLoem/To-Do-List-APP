part of 'sign_up_screen_view.dart';

class SignUpScreenViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final trimmedFullName = fullName.trim();
    final trimmedEmail = email.trim();

    if (trimmedFullName.isEmpty ||
        trimmedEmail.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      await _authServices.signUp(
        fullname: trimmedFullName,
        email: trimmedEmail,
        password: password,
        confirmPassword:
            confirmPassword, // Make sure auth_services.dart is updated as discussed earlier!
      );
      Get.toNamed(
        AppRoutes.signIn,
      ); // Navigate to the Sign In screen after successful sign-up

      Get.snackbar('Success', 'Account created successfully');

      // Option 2: If you are using named routes in GetX (e.g., GetMaterialApp with getPages)
      // Get.offNamed('/sign-in'); // Replace '/sign-in' with your actual route name

      // Option 3: Direct navigation to the view
      // Get.off(() => const SignInScreenView(), binding: SignInScreenViewBinding());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

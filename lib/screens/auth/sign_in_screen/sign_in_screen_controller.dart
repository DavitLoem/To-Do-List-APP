part of 'sign_in_screen_view.dart';

class SignInScreenViewController extends GetxController {
  final AuthServices _authServices = AuthServices();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> signIn({required String email, required String password}) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    try {
      isLoading.value = true;

      // AuthServices.signIn() already extracts and persists the tokens
      // (access_token / refresh_token) into secure storage, so the
      // AuthInterceptor can attach them to future requests.
      await _authServices.signIn(email: trimmedEmail, password: password);

      Get.snackbar('Success', 'Logged in successfully');

      // Navigate to My Task
      Get.offAllNamed(AppRoutes.myTask);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

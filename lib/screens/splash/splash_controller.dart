import 'package:get/get.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';
import 'package:to_do_list/routes/app_page.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Give the splash screen a moment to be visible before navigating.
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await TokenStorage.getAccessToken();
    final isLoggedIn = accessToken != null && accessToken.isNotEmpty;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.myTask);
    } else {
      Get.offAllNamed(AppRoutes.signIn);
    }
  }
}

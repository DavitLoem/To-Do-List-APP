part of 'sign_in_screen_view.dart';

class SignInScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInScreenViewController());
  }
}
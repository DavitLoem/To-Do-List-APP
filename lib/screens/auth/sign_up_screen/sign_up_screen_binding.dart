part of 'sign_up_screen_view.dart';

class SignUpScreenViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpScreenViewController());
  }
}

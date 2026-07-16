import 'package:get/get.dart';
import 'setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    // Check if controller already exists (injected in main.dart)
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(), permanent: true);
    }
  }
}

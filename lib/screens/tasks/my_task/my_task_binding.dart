import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:to_do_list/screens/tasks/my_task/my_task_controller.dart';

class MyTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTaskViewController>(() => MyTaskViewController());
  }
}

part of 'add_task_view.dart';

class AddTaskViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddTaskViewController());
  }
}
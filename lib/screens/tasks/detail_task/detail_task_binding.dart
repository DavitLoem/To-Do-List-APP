part of 'detail_task_view.dart';

class DetailTaskViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailTaskViewController());
  }
}
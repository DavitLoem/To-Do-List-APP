part of 'detail_task_view.dart';

class DetailTaskViewController extends GetxController {
  final TaskServices _taskServices = TaskServices();

  late Rx<TaskModel> task;
  final RxString currentStatus = 'pending'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Safely extract the task passed from your dashboard navigation arguments[cite: 14]
    if (Get.arguments != null && Get.arguments is TaskModel) {
      task = Rx<TaskModel>(Get.arguments as TaskModel);
      currentStatus.value = task.value.status.toLowerCase();
    } else {
      Get.back();
      Get.snackbar('Error', 'Task details could not be loaded.');
    }
  }

  // Updates status reactively and hits the server endpoint instantly
  Future<void> updateStatus(String newStatus) async {
    if (currentStatus.value == newStatus) return;

    try {
      isLoading.value = true;
      final updatedTask = TaskModel(
        id: task.value.id,
        title: task.value.title,
        description: task.value.description,
        status: newStatus,
        priority: task.value.priority,
        categoryId: task.value.categoryId,
        dueDate: task.value.dueDate,
        isFavorite: task.value.isFavorite,
        isArchived: task.value.isArchived,
        userId: task.value.userId,
        isDeleted: task.value.isDeleted,
        createdAt: task.value.createdAt,
        updatedAt: DateTime.now(),
      );

      await _taskServices.updateTask(updatedTask.id, updatedTask);
      task.value = updatedTask;
      currentStatus.value = newStatus;

      Get.snackbar(
        'Status Updated',
        'Task is now ${newStatus.capitalizeFirst}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A8B6A),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to modify status.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Routes smoothly right into the edit setup we wired up earlier
  void goToEditTask() async {
    final result = await Get.toNamed('/add-task', arguments: task.value);
    if (result == true) {
      // If task was altered during edit view state, pop cleanly to force dashboard update refresh workflow[cite: 10]
      Get.back(result: true);
    }
  }
}

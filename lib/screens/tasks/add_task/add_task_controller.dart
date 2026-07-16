part of 'add_task_view.dart';

class AddTaskViewController extends GetxController {
  final TaskServices _taskServices = TaskServices();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Reactive properties for real-time form state & preview card updates
  final RxString rxTitle = ''.obs;
  final RxString rxDescription = ''.obs;
  final Rx<DateTime> selectedDueDate = DateTime.now().obs;
  final RxString selectedPriority = 'medium'.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isLoading = false.obs;

  // Edit Mode Flag & Reference Task Model Storage
  final RxBool isUpdate = false.obs;
  TaskModel? existingTask;

  final List<String> priorityOptions = ['low', 'medium', 'high'];

  @override
  void onInit() {
    super.onInit();

    // Listen to text changes to update the live preview card instantly[cite: 25]
    titleController.addListener(() => rxTitle.value = titleController.text);
    descriptionController.addListener(
      () => rxDescription.value = descriptionController.text,
    );

    // Check if arguments have a TaskModel passed from the edit action button[cite: 25]
    if (Get.arguments != null && Get.arguments is TaskModel) {
      isUpdate.value = true;
      existingTask = Get.arguments as TaskModel;

      // Populate text editing controllers and states with existing database records[cite: 25]
      titleController.text = existingTask!.title;
      descriptionController.text = existingTask!.description;
      selectedDueDate.value = existingTask!.dueDate;
      selectedPriority.value = existingTask!.priority.toLowerCase();
      isFavorite.value = existingTask!.isFavorite;

      // Manually trigger preview update strings[cite: 25]
      rxTitle.value = existingTask!.title;
      rxDescription.value = existingTask!.description;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        // Dynamically adjust DatePicker theme for dark/light mode
        data: Theme.of(context).copyWith(
          colorScheme: isDark
              ? const ColorScheme.dark(
                  primary: Color(0xFF5A8B6A),
                  onPrimary: Colors.white,
                  surface: Color(0xFF1E1E1E), // AppColors.darkSurface
                  onSurface: Colors.white,
                )
              : const ColorScheme.light(
                  primary: Color(0xFF5A8B6A),
                  onPrimary: Colors.white,
                  onSurface: Colors.black87,
                ),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDueDate.value = picked;
  }

  // Unified submission method handling both Create and Update flows[cite: 25]
  Future<void> submitTask() async {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Title is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final task = TaskModel(
        id: isUpdate.value ? existingTask!.id : '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: isUpdate.value ? existingTask!.status : 'pending',
        priority: selectedPriority.value,
        categoryId: isUpdate.value ? existingTask!.categoryId : '1',
        dueDate: selectedDueDate.value,
        isFavorite: isFavorite.value,
        isArchived: true,
        userId: isUpdate.value ? existingTask!.userId : '1',
        isDeleted: isUpdate.value ? existingTask!.isDeleted : false,
        createdAt: isUpdate.value ? existingTask!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isUpdate.value) {
        await _taskServices.updateTask(task.id, task);
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Task updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF5A8B6A),
          colorText: Colors.white,
        );
      } else {
        await _taskServices.addTask(task);
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Task added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF5A8B6A),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        isUpdate.value ? 'Failed to update task' : 'Failed to add task',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // NOTE: The TextEditingControllers are intentionally NOT disposed here.
    // They are referenced by the view's TextField widgets, and disposing them
    // in onClose can occur while the widget is still alive/rebuilding during
    // navigation, causing "TextEditingController used after being disposed".
    // They become eligible for garbage collection once both the view and this
    // controller are removed.
    super.onClose();
  }
}

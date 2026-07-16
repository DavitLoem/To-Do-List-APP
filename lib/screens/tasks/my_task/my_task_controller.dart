import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/api/services/task_services.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';
import 'package:to_do_list/model/add_task_model.dart';
import 'package:to_do_list/routes/app_page.dart';

class MyTaskViewController extends GetxController {
  final TaskServices _taskServices = TaskServices();
  final AuthServices _authServices = AuthServices();

  final RxBool isLoading = false.obs;

  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxList<TaskModel> filteredTasks = <TaskModel>[].obs;

  // Profile State variables
  final RxString userName = 'Loading...'.obs;
  final RxString userEmail = 'Loading...'.obs;
  final RxString profileImageUrl = ''.obs;

  // Date State
  final RxList<DateTime> dateList = <DateTime>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> visibleMonthDate = DateTime.now().obs;

  // Changed to true so "All" tasks is selected by default on restart
  final RxBool isAllDatesSelected = true.obs;

  final ScrollController dateScrollController = ScrollController();
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _generateDateList();
    fetchTasks();
    fetchUserProfile();

    // Automatically filter tasks locally whenever the tab changes
    ever(tabIndex, (_) => _filterTasks());

    dateScrollController.addListener(() {
      double offset = dateScrollController.offset;
      int index = (offset / 77).round(); // 77 accounts for card width + margins

      if (index < 0) index = 0;
      if (index >= dateList.length) index = dateList.length - 1;

      if (visibleMonthDate.value.month != dateList[index].month) {
        visibleMonthDate.value = dateList[index];
      }
    });
  }

  @override
  void onClose() {
    dateScrollController.dispose();
    super.onClose();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _authServices.getProfile();

      if (response != null) {
        // FIXED: Handles both nested 'user' objects and direct responses
        final userData = response['user'] ?? response;

        userName.value = userData['fullname'] ?? 'User';
        userEmail.value = userData['email'] ?? 'No email';
        profileImageUrl.value = userData['profile_image'] ?? '';
      }
    } catch (e) {
      print("Error fetching profile: $e");
      userName.value = 'User';
      userEmail.value = '';
    }
  }

  void _generateDateList() {
    DateTime today = DateTime.now();
    for (int i = -5; i < 25; i++) {
      dateList.add(today.add(Duration(days: i)));
    }
    selectedDate.value = today;
    visibleMonthDate.value = today;
    isAllDatesSelected.value = true;
  }

  void selectDate(DateTime date) {
    isAllDatesSelected.value = false;
    selectedDate.value = date;
    _filterTasks();
  }

  void selectAllDates() {
    isAllDatesSelected.value = true;
    _filterTasks();
  }

  void switchTab(int index) {
    tabIndex.value = index;
  }

  void _filterTasks() {
    filteredTasks.assignAll(
      allTasks.where((task) {
        // --- Date Filter ---
        bool dateMatches = false;
        if (isAllDatesSelected.value) {
          dateMatches = true;
        } else {
          final taskDate = DateTime(
            task.dueDate.year,
            task.dueDate.month,
            task.dueDate.day,
          );
          final currentSelection = DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
          );
          final today = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );

          if (currentSelection == today) {
            dateMatches = taskDate.isBefore(today) || taskDate == today;
          } else {
            dateMatches = taskDate == currentSelection;
          }
        }

        // --- Status Filter ---
        bool statusMatches = false;
        String s = task.status.toLowerCase();
        if (tabIndex.value == 0 && s == 'pending') statusMatches = true;
        if (tabIndex.value == 1 && (s == 'in_progress' || s == 'in progress')) {
          statusMatches = true;
        }
        if (tabIndex.value == 2 && s == 'completed') statusMatches = true;

        return dateMatches && statusMatches;
      }).toList(),
    );
  }

  int getCountForTab(int tabIndexToCheck) {
    return allTasks.where((task) {
      bool dateMatches = false;
      if (isAllDatesSelected.value) {
        dateMatches = true;
      } else {
        final taskDate = DateTime(
          task.dueDate.year,
          task.dueDate.month,
          task.dueDate.day,
        );
        final currentSelection = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
        );
        final today = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );

        if (currentSelection == today) {
          dateMatches = taskDate.isBefore(today) || taskDate == today;
        } else {
          dateMatches = taskDate == currentSelection;
        }
      }

      bool statusMatches = false;
      String s = task.status.toLowerCase();
      if (tabIndexToCheck == 0 && s == 'pending') statusMatches = true;
      if (tabIndexToCheck == 1 && (s == 'in_progress' || s == 'in progress')) {
        statusMatches = true;
      }
      if (tabIndexToCheck == 2 && s == 'completed') statusMatches = true;

      return dateMatches && statusMatches;
    }).length;
  }

  int getTasksCountForMonth(int month, int year) {
    return allTasks
        .where(
          (task) => task.dueDate.month == month && task.dueDate.year == year,
        )
        .length;
  }

  bool hasTasksOnDate(DateTime date) {
    return allTasks.any(
      (task) =>
          task.dueDate.year == date.year &&
          task.dueDate.month == date.month &&
          task.dueDate.day == date.day,
    );
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final response = await _taskServices.getTasks(isArchived: true);

      if (response != null) {
        allTasks.assignAll(
          (response as List).map((e) => TaskModel.fromJson(e)).toList(),
        );
        _filterTasks();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      isLoading.value = true;
      await _taskServices.deleteTask(id);

      Get.snackbar(
        'Success',
        'Task deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A8B6A),
        colorText: Colors.white,
      );

      await fetchTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete task',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetail(TaskModel task) async {
    final result = await Get.toNamed('/detail-task', arguments: task);
    if (result == true) {
      fetchTasks();
    }
  }

  void navigateToUpdate(TaskModel task) async {
    final result = await Get.toNamed(AppRoutes.addTask, arguments: task);
    if (result == true) {
      fetchTasks();
    }
  }

  void navigateToAdd() async {
    final result = await Get.toNamed('/add-task');
    if (result == true) {
      fetchTasks();
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        isLoading.value = true;

        final imagePath = image.path;
        print('Uploading image: $imagePath');

        final response = await _authServices.uploadProfileImage(imagePath);
        print('Upload response: $response');

        if (response != null) {
          await fetchUserProfile();
          Get.snackbar(
            'Success',
            'Profile image uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF5A8B6A),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar(
        'Error',
        'Failed to upload profile image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      // Tell the backend to invalidate the token (if possible)
      await _authServices.logout();
    } catch (e) {
      print('Backend logout failed, but forcing local logout anyway.');
    } finally {
      // 1. ALWAYS clear tokens locally
      await TokenStorage.clearTokens();

      // 2. ALWAYS navigate to sign-in screen
      Get.offAllNamed('/sign-in');

      // 3. Stop loading and show success
      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A8B6A),
        colorText: Colors.white,
      );
    }
  }
}

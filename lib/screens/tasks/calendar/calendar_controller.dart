import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/api/services/task_services.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';
import 'package:to_do_list/model/add_task_model.dart';
import 'package:to_do_list/routes/app_page.dart';

class CalendarController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final TaskServices _taskServices = TaskServices();

  final RxBool isLoading = false.obs;
  final RxString profileImageUrl = ''.obs;

  // Drawer Profile Data
  final RxString userName = 'Loading...'.obs;
  final RxString userEmail = 'Loading...'.obs;

  // Calendar State
  final Rx<DateTime> focusedDate = DateTime.now().obs; // The month being viewed
  final Rx<DateTime> selectedDate =
      DateTime.now().obs; // The specifically tapped day

  // Task State
  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxList<TaskModel> selectedDayTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchTasks();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _authServices.getProfile();
      if (response != null && response['user'] != null) {
        userName.value = response['user']['fullname'] ?? 'User';
        userEmail.value = response['user']['email'] ?? 'No email';
        profileImageUrl.value = response['user']['profile_image'] ?? '';
      }
    } catch (e) {
      userName.value = 'User';
      userEmail.value = '';
      profileImageUrl.value = '';
    }
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final response = await _taskServices.getTasks(isArchived: true);

      if (response != null) {
        allTasks.assignAll(
          (response as List).map((e) => TaskModel.fromJson(e)).toList(),
        );
        _filterTasksForSelectedDay();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Calendar Logic ---

  void nextMonth() {
    focusedDate.value = DateTime(
      focusedDate.value.year,
      focusedDate.value.month + 1,
      1,
    );
  }

  void previousMonth() {
    focusedDate.value = DateTime(
      focusedDate.value.year,
      focusedDate.value.month - 1,
      1,
    );
  }

  void onDaySelected(DateTime date) {
    selectedDate.value = date;
    _filterTasksForSelectedDay();
  }

  void _filterTasksForSelectedDay() {
    selectedDayTasks.assignAll(
      allTasks.where((task) {
        return task.dueDate.year == selectedDate.value.year &&
            task.dueDate.month == selectedDate.value.month &&
            task.dueDate.day == selectedDate.value.day;
      }).toList(),
    );
  }

  bool hasTasksOnDate(DateTime date) {
    return allTasks.any(
      (task) =>
          task.dueDate.year == date.year &&
          task.dueDate.month == date.month &&
          task.dueDate.day == date.day,
    );
  }

  // --- Task Navigation ---
  void navigateToDetail(TaskModel task) async {
    final result = await Get.toNamed('/detail-task', arguments: task);
    if (result == true) fetchTasks();
  }

  void navigateToUpdate(TaskModel task) async {
    final result = await Get.toNamed(AppRoutes.addTask, arguments: task);
    if (result == true) fetchTasks();
  }

  void navigateToAdd() async {
    final result = await Get.toNamed('/add-task');
    if (result == true) fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    try {
      isLoading.value = true;
      await _taskServices.deleteTask(id);
      Get.snackbar(
        'Success',
        'Task deleted successfully',
        backgroundColor: const Color(0xFF5A8B6A),
        colorText: Colors.white,
      );
      await fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Call logout API
      await _authServices.logout();

      // Clear tokens
      await TokenStorage.clearTokens();

      // Navigate to login screen
      Get.offAllNamed('/sign-in');

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF5A8B6A),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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

        // Call the upload API
        final response = await _authServices.uploadProfileImage(imagePath);

        print('Upload response: $response');

        if (response != null) {
          // Refresh profile to get the updated image URL
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
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/api/services/task_services.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';
import 'package:to_do_list/model/add_task_model.dart';

class DashboardController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final TaskServices _taskServices = TaskServices();

  final RxBool isLoading = false.obs;

  // Profile state for the drawer
  final RxString userName = 'Loading...'.obs;
  final RxString userEmail = 'Loading...'.obs;
  final RxString profileImageUrl = ''.obs;

  // Statistics
  final RxInt totalTasks = 0.obs;
  final RxInt pendingTasks = 0.obs;
  final RxInt inProgressTasks = 0.obs;
  final RxInt completedTasks = 0.obs;

  @override
  void onInit() {
    super.onInit();

    fetchDashboardData();
  }

  Future<void> fetchUserProfile() async {
    try {
      final profileResponse = await _authServices.getProfile();
      if (profileResponse != null && profileResponse['user'] != null) {
        userName.value = profileResponse['user']['fullname'] ?? 'User';
        userEmail.value = profileResponse['user']['email'] ?? 'No email';
        profileImageUrl.value = profileResponse['user']['profile_image'] ?? '';
      }
    } catch (e) {
      userName.value = 'User';
      userEmail.value = '';
      profileImageUrl.value = '';
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // 1. Fetch User Profile for Greeting & Drawer
      await fetchUserProfile();

      // 2. Fetch All Tasks to calculate statistics
      final tasksResponse = await _taskServices.getTasks(isArchived: true);

      if (tasksResponse != null) {
        List<TaskModel> tasks = (tasksResponse as List)
            .map((e) => TaskModel.fromJson(e))
            .toList();

        totalTasks.value = tasks.length;

        pendingTasks.value = tasks
            .where((t) => t.status.toLowerCase() == 'pending')
            .length;

        inProgressTasks.value = tasks.where((t) {
          String s = t.status.toLowerCase();
          return s == 'in_progress' || s == 'in progress';
        }).length;

        completedTasks.value = tasks
            .where((t) => t.status.toLowerCase() == 'completed')
            .length;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard statistics');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToTasks() {
    Get.offNamed('/my-task'); // Update with your actual task route
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

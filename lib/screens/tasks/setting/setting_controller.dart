import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';

class SettingController extends GetxController {
  final AuthServices _authServices = AuthServices();

  // Drawer Profile Data
  final RxString userName = 'Loading...'.obs;
  final RxString userEmail = 'Loading...'.obs;
  final RxString profileImageUrl = ''.obs;
  var isLoading = false.obs;

  // Mock Settings Toggles
  final RxBool isNotificationsEnabled = true.obs;
  final RxBool isDarkModeEnabled = false.obs;
  final RxBool isFingerprintEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    loadThemePreference();
  }

  // --- Load and Save Theme ---
  Future<void> loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkModeEnabled.value = prefs.getBool('isDarkMode') ?? false;
    } catch (e) {
      print('SharedPreferences error: $e');
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkModeEnabled.value = value;

    // Actually change the GetX theme mode instantly
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', value);
    } catch (e) {
      print('SharedPreferences error: $e');
    }
  }
  // ---------------------------

  void toggleNotifications(bool value) => isNotificationsEnabled.value = value;
  void toggleFingerprint(bool value) => isFingerprintEnabled.value = value;

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

  Future<void> uploadProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        isLoading.value = true;
        final imagePath = image.path;
        final response = await _authServices.uploadProfileImage(imagePath);

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

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      final response = await _authServices.updateProfile(
        fullname: name,
        email: email,
      );

      if (response != null) {
        await fetchUserProfile();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF5A8B6A),
          colorText: Colors.white,
        );
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      final response = await _authServices.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response != null) {
        Get.back();
        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF5A8B6A),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: $e',
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
      await _authServices.logout();
      await TokenStorage.clearTokens();
      Get.offAllNamed('/sign-in');
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
}

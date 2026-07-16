import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/screens/widget/app_drawer.dart';
import 'setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Dynamic Theme Variables
      final bool isDark = controller.isDarkModeEnabled.value;
      final bgColor = isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground;
      final textColor = isDark ? AppColors.darkText : AppColors.lightText;

      // FIX: Use grey100 for light mode instead of lightCard (which is white)
      final cardColor = isDark ? AppColors.darkCard : AppColors.grey100;

      final surfaceColor = isDark
          ? AppColors.darkSurface
          : AppColors.lightSurface;
      final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      final subtitleColor = isDark
          ? AppColors.darkSubtitle
          : AppColors.lightSubtitle;
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 18, height: 2.5, color: AppColors.primary),
                  const SizedBox(height: 4),
                  Container(width: 12, height: 2.5, color: AppColors.primary),
                  const SizedBox(height: 4),
                  Container(width: 18, height: 2.5, color: AppColors.primary),
                ],
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
        ),

        // Pass data to your beautifully extracted Drawer widget!
        drawer: AppDrawer(
          userName: controller.userName.value,
          userEmail: controller.userEmail.value,
          profileImageUrl: controller.profileImageUrl.value,
          isDark: isDark,
          onUploadImage: controller.uploadProfileImage,
          onLogout: controller.logout,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.uploadProfileImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.grey200,
                          backgroundImage:
                              controller.profileImageUrl.value.isNotEmpty
                              ? NetworkImage(controller.profileImageUrl.value)
                              : null,
                          child: controller.profileImageUrl.value.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 36,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userName.value,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.userEmail.value,
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showEditProfileDialog(
                        bgColor,
                        textColor,
                        surfaceColor,
                        borderColor,
                      ),
                      icon: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Preferences', textColor),
              const SizedBox(height: 16),

              _buildToggleItem(
                icon: Icons.notifications_none_rounded,
                title: 'Push Notifications',
                value: controller.isNotificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                cardColor: cardColor,
                textColor: textColor,
              ),
              _buildToggleItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: controller.isDarkModeEnabled.value,
                onChanged: controller.toggleDarkMode,
                cardColor: cardColor,
                textColor: textColor,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('Security', textColor),
              const SizedBox(height: 16),

              _buildNavigationItem(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: () => _showChangePasswordDialog(
                  bgColor,
                  textColor,
                  surfaceColor,
                  borderColor,
                ),
                cardColor: cardColor,
                textColor: textColor,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('About', textColor),
              const SizedBox(height: 16),

              _buildNavigationItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
                cardColor: cardColor,
                textColor: textColor,
              ),
              _buildNavigationItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () {},
                cardColor: cardColor,
                textColor: textColor,
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Logout',
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      middleText: 'Are you sure you want to log out?',
                      textConfirm: 'Logout',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      buttonColor: const Color(0xFFA62A22), // Red
                      cancelTextColor: Colors.black54,
                      onConfirm: () {
                        Get.back();
                        controller.logout();
                      },
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFA62A22,
                    ), // Red for danger action
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  // --- Setting UI Components ---

  void _showEditProfileDialog(
    Color bgColor,
    Color textColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    final nameController = TextEditingController(
      text: controller.userName.value,
    );
    final emailController = TextEditingController(
      text: controller.userEmail.value,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: bgColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildDialogTextField(
                nameController,
                'Full Name',
                textColor,
                surfaceColor,
                borderColor,
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                emailController,
                'Email',
                textColor,
                surfaceColor,
                borderColor,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: borderColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.updateProfile(
                                  name: nameController.text,
                                  email: emailController.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showChangePasswordDialog(
    Color bgColor,
    Color textColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: bgColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildDialogTextField(
                oldPasswordController,
                'Old Password',
                textColor,
                surfaceColor,
                borderColor,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                newPasswordController,
                'New Password',
                textColor,
                surfaceColor,
                borderColor,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                confirmPasswordController,
                'Confirm Password',
                textColor,
                surfaceColor,
                borderColor,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: borderColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (newPasswordController.text !=
                                    confirmPasswordController.text) {
                                  Get.snackbar(
                                    'Error',
                                    'Passwords do not match',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppColors.error,
                                    colorText: AppColors.white,
                                  );
                                  return;
                                }
                                controller.changePassword(
                                  oldPassword: oldPasswordController.text,
                                  newPassword: newPasswordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildDialogTextField(
    TextEditingController txtController,
    String label,
    Color textColor,
    Color surfaceColor,
    Color borderColor, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: txtController,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.grey500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: surfaceColor,
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.white,
        activeTrackColor: AppColors.primary,
        inactiveThumbColor: AppColors.white,
        inactiveTrackColor: AppColors.grey300,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          splashColor: AppColors.primary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.grey500,
          ),
        ),
      ),
    );
  }
}

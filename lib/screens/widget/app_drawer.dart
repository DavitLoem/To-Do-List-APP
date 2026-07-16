import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImageUrl;
  final VoidCallback onLogout;
  final VoidCallback? onUploadImage;
  final bool isDark;

  const AppDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.profileImageUrl,
    required this.onLogout,
    this.onUploadImage,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    // Flawless Dark & Light mode integration for Drawer
    // final drawerBg = isDark ? AppColors.darkBackground : AppColors.primary;
    final itemBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.primary;
    final subTextColor = isDark ? AppColors.darkSubtitle : AppColors.primary;
    final dividerColor = isDark ? AppColors.darkBorder : Colors.white;

    return Drawer(
      backgroundColor: AppColors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            // Welcome Text
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  color: isDark ? AppColors.darkText : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile Card
            Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.only(
                left: 20,
                top: 12,
                bottom: 12,
                right: 12,
              ),
              decoration: BoxDecoration(
                color: itemBg,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userEmail,
                          style: TextStyle(color: subTextColor, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onUploadImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: itemBg, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.grey200,
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: profileImageUrl.isEmpty
                            ? Icon(
                                Icons.person,
                                color: isDark
                                    ? AppColors.darkSurface
                                    : AppColors.primary,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            // Divider Line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Divider(color: dividerColor, height: 1, thickness: 1),
            ),
            const SizedBox(height: 32),

            // Menu Items
            _buildDrawerItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              itemBg: itemBg,
              textColor: textColor,
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.dasboard);
              },
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              icon: Icons.bar_chart_rounded,
              label: 'Task',
              itemBg: itemBg,
              textColor: textColor,
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.myTask);
              },
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              icon: Icons.calendar_today_rounded,
              label: 'Calendar',
              itemBg: itemBg,
              textColor: textColor,
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.calendar);
              },
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              label: 'Setting',
              itemBg: itemBg,
              textColor: textColor,
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.setting);
              },
            ),
            const SizedBox(height: 20),
            if (onUploadImage != null)
              _buildDrawerItem(
                icon: Icons.upload_file_rounded,
                label: 'Upload Profile',
                itemBg: itemBg,
                textColor: textColor,
                onTap: () {
                  Get.back();
                  onUploadImage!();
                },
              ),
            const Spacer(),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              itemBg: itemBg,
              textColor: textColor,
              isDestructive: true,
              onTap: () {
                Get.back(); // Close the drawer first

                // Show a beautiful custom dialog
                Get.dialog(
                  Dialog(
                    backgroundColor: isDark
                        ? AppColors.darkSurface
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top Icon surrounded by a soft red circle
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA62A22).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Color(0xFFA62A22),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Subtitle Description
                          Text(
                            'Are you sure you want to log out of your account? You will need to enter your credentials to log back in.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkSubtitle
                                  : Colors.black54,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Side-by-side Buttons
                          Row(
                            children: [
                              // Cancel Button (Outlined)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Logout Button (Solid Red)
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back(); // Close the dialog
                                    onLogout(); // Trigger your actual logout logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: const Color(0xFFA62A22),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                  barrierDismissible: true, // Allows tapping outside to close
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required Color itemBg,
    required Color textColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    // Red color for logout, dynamic theme color for everything else
    final contentColor = isDestructive ? const Color(0xFFA62A22) : textColor;

    return Container(
      margin: const EdgeInsets.only(right: 56),
      child: Material(
        color: itemBg,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: contentColor, size: 24),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

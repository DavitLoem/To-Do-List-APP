import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/routes/app_routes.dart';
import 'package:to_do_list/screens/widget/app_drawer.dart'; // Ensure this path is correct
import 'package:to_do_list/screens/tasks/dashboard_screen/dashboard_screen_controller.dart';

class DashboardScreenView extends GetView<DashboardController> {
  const DashboardScreenView({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    // Detect dark mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Define adaptive colors
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final subtitleColor = isDark
        ? AppColors.darkSubtitle
        : AppColors.lightSubtitle;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bgColor,
      // Integration of shared AppDrawer
      drawer: Obx(
        () => AppDrawer(
          userName: controller.userName.value,
          userEmail: controller.userEmail.value,
          profileImageUrl: controller.profileImageUrl.value,
          isDark: isDark,
          onLogout: controller.logout,
          onUploadImage: controller.uploadProfileImage,
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.fetchDashboardData,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(context, isDark)),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 15,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formattedDate(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1.25,
                            ),
                        delegate: SliverChildListDelegate([
                          _buildStatCard(
                            'Total Tasks',
                            controller.totalTasks.value,
                            Icons.assignment_rounded,
                            AppColors.primary,
                            cardColor,
                            textColor,
                            subtitleColor,
                          ),
                          _buildStatCard(
                            'Pending',
                            controller.pendingTasks.value,
                            Icons.pending_actions_rounded,
                            AppColors.warning,
                            cardColor,
                            textColor,
                            subtitleColor,
                          ),
                          _buildStatCard(
                            'In Progress',
                            controller.inProgressTasks.value,
                            Icons.timelapse_rounded,
                            AppColors.info,
                            cardColor,
                            textColor,
                            subtitleColor,
                          ),
                          _buildStatCard(
                            'Completed',
                            controller.completedTasks.value,
                            Icons.check_circle_rounded,
                            AppColors.success,
                            cardColor,
                            textColor,
                            subtitleColor,
                          ),
                        ]),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            controller.totalTasks.value == 0
                                ? _buildEmptyState(textColor, subtitleColor)
                                : _buildCallToAction(),
                            const SizedBox(height: 24),
                            Text(
                              'Quick Actions',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildQuickAction(
                                    Icons.calendar_month_rounded,
                                    'Calendar',
                                    AppColors.info,
                                    cardColor,
                                    textColor,
                                    borderColor,
                                    onTap: () =>
                                        Get.toNamed(AppRoutes.calendar),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildQuickAction(
                                    Icons.settings_rounded,
                                    'Settings',
                                    AppColors.grey600,
                                    cardColor,
                                    textColor,
                                    borderColor,
                                    onTap: () => Get.toNamed(AppRoutes.setting),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Center(
                              child: Text(
                                controller.totalTasks.value == 0
                                    ? 'Stay on top of things, one task at a time'
                                    : 'You\'re doing great, keep it up!',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: subtitleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final total = controller.totalTasks.value;
    final completed = controller.completedTasks.value;
    final progress = total == 0 ? 0.0 : completed / total;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [AppColors.darkSurface, AppColors.darkSurface]
                  : [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => _iconButton(
                        icon: Icons.menu_rounded,
                        onTap: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => controller.uploadProfileImage(),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        backgroundImage:
                            controller.profileImageUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileImageUrl.value)
                            : null,
                        child: controller.profileImageUrl.value.isEmpty
                            ? const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 22,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _greeting() + ',',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Here is your task summary for today',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: -34,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress == 0 ? null : progress,
                        strokeWidth: 5,
                        backgroundColor: AppColors.grey200,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Progress",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        total == 0
                            ? 'No tasks yet'
                            : '$completed of $total tasks completed',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark
                              ? AppColors.darkSubtitle
                              : AppColors.lightSubtitle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    IconData icon,
    Color color,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    Color cardColor,
    Color textColor,
    Color borderColor, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallToAction() {
    return ElevatedButton.icon(
      onPressed: controller.navigateToTasks,
      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
      label: const Text(
        'View All Tasks',
        style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color subtitleColor) {
    return Column(
      children: [
        Icon(
          Icons.checklist_rtl_rounded,
          size: 56,
          color: AppColors.primaryLight,
        ),
        const SizedBox(height: 12),
        Text(
          'No tasks yet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Create your first task to get started',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: subtitleColor),
        ),
        const SizedBox(height: 20),
        _buildCallToAction(),
      ],
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  String _formattedDate() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final now = DateTime.now();
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}

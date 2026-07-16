import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/model/add_task_model.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/screens/widget/app_drawer.dart';
import 'calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Theme detection
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final textColor = isDark ? AppColors.darkText : Colors.black87;
    final calendarBg = isDark ? AppColors.darkCard : const Color(0xFFF5F7F5);
    final secondaryTextColor = isDark
        ? AppColors.darkSubtitle
        : Colors.grey.shade600;

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
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2, right: 2),
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      // 2. Using Shared AppDrawer
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
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAdd,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Obx(
        () => controller.isLoading.value && controller.allTasks.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Column(
                children: [
                  const SizedBox(height: 12),
                  _buildCalendar(
                    textColor,
                    calendarBg,
                    secondaryTextColor,
                    isDark,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat(
                            'MMM dd, yyyy',
                          ).format(controller.selectedDate.value),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${controller.selectedDayTasks.length} Tasks',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: controller.selectedDayTasks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_available_rounded,
                                  size: 60,
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : Colors.grey.shade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No tasks for this day',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkSubtitle
                                        : Colors.grey.shade500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 80,
                            ),
                            itemCount: controller.selectedDayTasks.length,
                            itemBuilder: (context, index) => _buildTaskCard(
                              controller.selectedDayTasks[index],
                              index,
                              context,
                              isDark,
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  // --- Custom Calendar UI ---
  Widget _buildCalendar(
    Color textColor,
    Color calendarBg,
    Color secondaryTextColor,
    bool isDark,
  ) {
    final focusedDate = controller.focusedDate.value;
    final selectedDate = controller.selectedDate.value;
    final int daysInMonth = DateTime(
      focusedDate.year,
      focusedDate.month + 1,
      0,
    ).day;
    final int firstWeekday = DateTime(
      focusedDate.year,
      focusedDate.month,
      1,
    ).weekday;
    final int emptySlots = firstWeekday - 1;
    final int totalGridItems = emptySlots + daysInMonth;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: calendarBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: textColor,
                  size: 28,
                ),
                onPressed: controller.previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(focusedDate),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: textColor,
                  size: 28,
                ),
                onPressed: controller.nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((day) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: totalGridItems,
            itemBuilder: (context, index) {
              if (index < emptySlots) return const SizedBox();
              final int dayNumber = index - emptySlots + 1;
              final DateTime thisDate = DateTime(
                focusedDate.year,
                focusedDate.month,
                dayNumber,
              );
              final bool isSelected =
                  thisDate.year == selectedDate.year &&
                  thisDate.month == selectedDate.month &&
                  thisDate.day == selectedDate.day;
              final bool isToday =
                  thisDate.year == DateTime.now().year &&
                  thisDate.month == DateTime.now().month &&
                  thisDate.day == DateTime.now().day;
              final bool hasTask = controller.hasTasksOnDate(thisDate);

              return GestureDetector(
                onTap: () => controller.onDaySelected(thisDate),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: (isSelected || isToday)
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected ? Colors.white : textColor,
                        ),
                      ),
                      if (hasTask)
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- Beautiful Task Card (Matches Home Screen) ---
  Widget _buildTaskCard(
    TaskModel task,
    int index,
    BuildContext context,
    bool isDark,
  ) {
    final cardColor = [
      AppColors.primary,
      const Color(0xFF385A52),
      const Color(0xFF865555),
    ][index % 3];

    final bool isFirstCard = (index % 3) == 0;

    // Dynamic text colors to ensure it's readable on all background colors
    final titleColor = isFirstCard
        ? (isDark ? Colors.white : const Color(0xFF163020))
        : Colors.white;
    final subColor = isFirstCard ? Colors.white70 : const Color(0xFFA5D1B5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Date Timeline
              Container(
                height: 135,
                padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      task.dueDate.day.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: AppDashedLine(
                          direction: Axis.vertical,
                          color: cardColor.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Text(
                      task.dueDate
                          .add(const Duration(days: 3))
                          .day
                          .toString()
                          .padLeft(2, '0'),
                      style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Right Task Card
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.navigateToDetail(task),
                  child: ClipPath(
                    clipper: TaskCardClipper(),
                    child: Container(
                      height: 135,
                      color: cardColor,
                      child: Stack(
                        children: [
                          // Status Badge
                          Positioned(
                            top: 14,
                            left: 20,
                            child: Text(
                              task.status.capitalizeFirst ?? 'Pending',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Inner Content (Rotated Icon, Text, and Menu)
                          Positioned(
                            top: 60,
                            left: 20,
                            right: 16,
                            child: Row(
                              children: [
                                // Rotated Diamond Icon container
                                Transform.rotate(
                                  angle: math.pi / 4,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1B2B38),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Transform.rotate(
                                      angle: -math.pi / 4,
                                      child: Icon(
                                        Icons.grid_view_rounded,
                                        color: cardColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Task Title and Description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title.isNotEmpty
                                            ? task.title
                                            : 'Task Title',
                                        style: TextStyle(
                                          color: titleColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        task.description.isNotEmpty
                                            ? task.description
                                            : 'Task Description',
                                        style: TextStyle(
                                          color: subColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // 3-Dots Action Menu
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: isDark
                                        ? AppColors.darkCard
                                        : Colors.white,
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert_rounded,
                                      color: isFirstCard
                                          ? Colors.black54
                                          : Colors.white70,
                                      size: 28,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'update') {
                                        controller.navigateToUpdate(task);
                                      } else if (value == 'delete') {
                                        _showDeleteDialog(task.id, isDark);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'update',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit_outlined,
                                              color: isDark
                                                  ? AppColors.darkText
                                                  : Colors.black87,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Update',
                                              style: TextStyle(
                                                color: isDark
                                                    ? AppColors.darkText
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              color: Color(
                                                0xFFA62A22,
                                              ), // Red error color
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Color(0xFFA62A22),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal Separator Line
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: AppDashedLine(
              direction: Axis.horizontal,
              color: isDark ? AppColors.darkBorder : const Color(0xFFD3E2D9),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to show the beautiful delete dialog
  void _showDeleteDialog(String taskId, bool isDark) {
    Get.defaultDialog(
      title: 'Delete Task',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.white : Colors.black87,
      ),
      middleText: 'Are you sure you want to move this task to trash?',
      middleTextStyle: TextStyle(
        color: isDark ? AppColors.darkSubtitle : Colors.black87,
      ),
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFA62A22),
      cancelTextColor: isDark ? AppColors.darkSubtitle : Colors.black54,
      onConfirm: () {
        Get.back();
        controller.deleteTask(taskId);
      },
    );
  }
}

// ==========================================
// UTILITY WIDGETS
// ==========================================

class AppDashedLine extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final Color color;
  final Axis direction;
  const AppDashedLine({
    super.key,
    this.dashWidth = 4,
    this.dashHeight = 2,
    this.color = const Color(0xFFBDD2C5),
    this.direction = Axis.horizontal,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : dashWidth;
        final boxHeight = direction == Axis.vertical
            ? constraints.constrainHeight()
            : dashHeight;
        final dashCount = direction == Axis.horizontal
            ? (boxWidth / (2 * dashWidth)).floor()
            : (boxHeight / (2 * dashHeight)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List.generate(
            dashCount,
            (_) => SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TaskCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double tabWidth = size.width * 0.42;
    const double tabHeight = 40.0;
    const double radius = 24.0;
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(tabWidth - 15, 0);
    path.cubicTo(
      tabWidth + 5,
      0,
      tabWidth - 5,
      tabHeight,
      tabWidth + 25,
      tabHeight,
    );
    path.lineTo(size.width - radius, tabHeight);
    path.quadraticBezierTo(
      size.width,
      tabHeight,
      size.width,
      tabHeight + radius,
    );
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

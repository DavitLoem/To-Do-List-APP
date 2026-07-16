import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/api/services/task_services.dart';
import 'package:to_do_list/core/api/utils/token_storage.dart';
import 'package:to_do_list/model/add_task_model.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/screens/tasks/my_task/my_task_controller.dart';
import 'package:to_do_list/screens/widget/app_drawer.dart';

class MyTaskView extends GetView<MyTaskViewController> {
  const MyTaskView({super.key});

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    // --- Dark Mode Variables ---
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final unselectedCardColor = isDark
        ? AppColors.darkCard
        : const Color(0xFFDCE6E0);
    // ---------------------------

    return Scaffold(
      backgroundColor: bgColor,
      drawer: Obx(
        () => AppDrawer(
          userName: controller.userName.value,
          userEmail: controller.userEmail.value,
          profileImageUrl: controller.profileImageUrl.value,
          isDark: isDark,
          onUploadImage: controller.uploadProfileImage,
          onLogout: controller.logout,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAdd,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white, size: 30),
      ),
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
          'My Task',
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
                      color: AppColors.white,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(() {
              String currentMonth = _getMonthName(
                controller.visibleMonthDate.value.month,
              );
              int nextMonthIndex = controller.visibleMonthDate.value.month == 12
                  ? 1
                  : controller.visibleMonthDate.value.month + 1;
              String nextMonth = _getMonthName(nextMonthIndex);
              int taskCount = controller.getTasksCountForMonth(
                controller.visibleMonthDate.value.month,
                controller.visibleMonthDate.value.year,
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        currentMonth,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      if (taskCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$taskCount Note${taskCount > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    nextMonth,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 85,
            child: Row(
              children: [
                Obx(() {
                  final isAllSelected = controller.isAllDatesSelected.value;
                  return GestureDetector(
                    onTap: controller.selectAllDates,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(
                        left: 24,
                        right: 6,
                        top: 4,
                        bottom: 4,
                      ),
                      width: 65,
                      decoration: BoxDecoration(
                        color: isAllSelected
                            ? AppColors.primary
                            : unselectedCardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'All',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isAllSelected
                                  ? AppColors.white
                                  : (isDark
                                        ? AppColors.darkText
                                        : AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tasks',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isAllSelected
                                  ? Colors.white70
                                  : (isDark
                                        ? AppColors.darkSubtitle
                                        : AppColors.primary.withOpacity(0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Expanded(
                  child: ListView.builder(
                    controller: controller.dateScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 20, left: 4),
                    itemCount: controller.dateList.length,
                    itemBuilder: (context, index) {
                      final date = controller.dateList[index];
                      return Obx(() {
                        final isSelected =
                            !controller.isAllDatesSelected.value &&
                            date.year == controller.selectedDate.value.year &&
                            date.month == controller.selectedDate.value.month &&
                            date.day == controller.selectedDate.value.day;
                        final hasTasks = controller.hasTasksOnDate(date);
                        return _buildDateCard(
                          date,
                          isSelected,
                          hasTasks,
                          isDark,
                          unselectedCardColor,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(
              () => Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      color: isDark
                          ? AppColors.darkBorder
                          : Colors.grey.shade300,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTab(
                          controller
                              .getCountForTab(0)
                              .toString()
                              .padLeft(2, '0'),
                          'To Do',
                          controller.tabIndex.value == 0,
                          0,
                        ),
                      ),
                      Expanded(
                        child: _buildTab(
                          controller
                              .getCountForTab(1)
                              .toString()
                              .padLeft(2, '0'),
                          'In Progress',
                          controller.tabIndex.value == 1,
                          1,
                        ),
                      ),
                      Expanded(
                        child: _buildTab(
                          controller
                              .getCountForTab(2)
                              .toString()
                              .padLeft(2, '0'),
                          'Completed',
                          controller.tabIndex.value == 2,
                          2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? _buildShimmerLoading(isDark)
                  : controller.filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkSubtitle
                              : Colors.black45,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 40,
                      ),
                      itemCount: controller.filteredTasks.length,
                      itemBuilder: (context, index) {
                        return _buildTaskCard(
                          controller.filteredTasks[index],
                          index,
                          context,
                          isDark,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
      itemCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ShimmerCard(isDark: isDark),
    );
  }

  Widget _buildDateCard(
    DateTime date,
    bool isSelected,
    bool hasTasks,
    bool isDark,
    Color unselectedBg,
  ) {
    String dayName = _getDayName(date.weekday);
    String dayNumber = date.day.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: () => controller.selectDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        width: 65,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : unselectedBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNumber,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.white
                    : (isDark ? AppColors.darkText : AppColors.primary),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white70
                    : (isDark
                          ? AppColors.darkSubtitle
                          : AppColors.primary.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: hasTasks
                    ? (isSelected ? AppColors.white : AppColors.primary)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String count, String label, bool isSelected, int tabIndex) {
    return GestureDetector(
      onTap: () => controller.switchTab(tabIndex),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: isSelected ? 4 : 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    count,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary.withOpacity(
                        isSelected ? 1.0 : 0.6,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  static const List<Color> _cardColors = [
    Color(0xFF5A8B6A), // Original Sage Green
    Color(0xFF5A798B), // Muted Steel Blue
    Color(0xFFB78536), // New: Warm Muted Amber
    Color(0xFF385A52), // Original Dark Slate
    Color(0xFF865555), // Original Deep Muted Red
    Color(0xFF2C5E7F), // New: Deep Muted Blue
    Color(0xFF8B6A5A), // Muted Terracotta
  ];

  Widget _buildTaskCard(
    TaskModel task,
    int index,
    BuildContext context,
    bool isDark,
  ) {
    final cardColor = _cardColors[index % _cardColors.length];
    final bool isFirstCard = (index % _cardColors.length) == 0;

    final titleColor = isFirstCard ? const Color(0xFF163020) : Colors.white;
    final subColor = isFirstCard ? Colors.white70 : const Color(0xFFA5D1B5);

    String topDay = task.dueDate.day.toString().padLeft(2, '0');
    String bottomDay = task.dueDate
        .add(const Duration(days: 3))
        .day
        .toString()
        .padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 135,
                padding: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topDay,
                      style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: AppDashedLine(
                          direction: Axis.vertical,
                          dashHeight: 4,
                          dashWidth: 1.5,
                          color: cardColor.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Text(
                      bottomDay,
                      style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
                          Positioned(
                            top: 60,
                            left: 20,
                            right: 16,
                            child: Row(
                              children: [
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title.isNotEmpty
                                            ? task.title
                                            : 'Home Work',
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
                                            : 'School Project',
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
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    cardColor: isDark
                                        ? AppColors.darkCard
                                        : AppColors.white,
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.black54,
                                      size: 28,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    onSelected: (value) {
                                      if (value == 'update') {
                                        controller.navigateToUpdate(task);
                                      } else if (value == 'delete') {
                                        Get.defaultDialog(
                                          title: 'Delete Task',
                                          titleStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                          middleText:
                                              'Are you sure you want to move this task to trash?',
                                          middleTextStyle: TextStyle(
                                            color: isDark
                                                ? AppColors.darkSubtitle
                                                : Colors.black87,
                                          ),
                                          backgroundColor: isDark
                                              ? AppColors.darkSurface
                                              : AppColors.lightSurface,
                                          textConfirm: 'Delete',
                                          textCancel: 'Cancel',
                                          confirmTextColor: Colors.white,
                                          buttonColor: AppColors.error,
                                          cancelTextColor: isDark
                                              ? AppColors.darkSubtitle
                                              : Colors.black54,
                                          onConfirm: () {
                                            Get.back();
                                            controller.deleteTask(task.id);
                                          },
                                        );
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
                                              color: AppColors.error,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Delete',
                                              style: const TextStyle(
                                                color: AppColors.error,
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
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: AppDashedLine(
              direction: Axis.horizontal,
              dashWidth: 4,
              dashHeight: 1.5,
              color: isDark
                  ? AppColors.darkBorder
                  : const Color(0xFFD3E2D9).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDrawer(BuildContext context, bool isDark) {
  //   // Flawless Dark & Light mode integration for Drawer
  //   final drawerBg = isDark ? AppColors.darkBackground : AppColors.primary;
  //   final itemBg = isDark ? AppColors.darkSurface : Colors.white;
  //   final textColor = isDark ? AppColors.darkText : AppColors.primary;
  //   final subTextColor = isDark ? AppColors.darkSubtitle : AppColors.primary;
  //   final dividerColor = isDark ? AppColors.darkBorder : Colors.white;

  //   return Drawer(
  //     backgroundColor: drawerBg,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(28),
  //         bottomRight: Radius.circular(28),
  //       ),
  //     ),
  //     child: SafeArea(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(height: 32),
  //           // Welcome Text
  //           Padding(
  //             padding: const EdgeInsets.only(left: 20),
  //             child: Text(
  //               'Welcome Back',
  //               style: TextStyle(
  //                 color: isDark ? AppColors.darkText : Colors.white,
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 16),

  //           // Profile Card
  //           Container(
  //             margin: const EdgeInsets.only(right: 24),
  //             padding: const EdgeInsets.only(
  //               left: 20,
  //               top: 12,
  //               bottom: 12,
  //               right: 12,
  //             ),
  //             decoration: BoxDecoration(
  //               color: itemBg,
  //               borderRadius: const BorderRadius.only(
  //                 topRight: Radius.circular(40),
  //                 bottomRight: Radius.circular(40),
  //               ),
  //             ),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Obx(
  //                     () => Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           controller.userName.value,
  //                           style: TextStyle(
  //                             color: textColor,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                         const SizedBox(height: 2),
  //                         Text(
  //                           controller.userEmail.value,
  //                           style: TextStyle(color: subTextColor, fontSize: 11),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 GestureDetector(
  //                   onTap: () => controller.uploadProfileImage(),
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(color: itemBg, width: 2),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.1),
  //                           blurRadius: 4,
  //                           spreadRadius: 1,
  //                         ),
  //                       ],
  //                     ),
  //                     child: Obx(
  //                       () => CircleAvatar(
  //                         radius: 26,
  //                         backgroundColor: AppColors.grey200,
  //                         backgroundImage:
  //                             controller.profileImageUrl.value.isNotEmpty
  //                             ? NetworkImage(controller.profileImageUrl.value)
  //                             : null,
  //                         child: controller.profileImageUrl.value.isEmpty
  //                             ? Icon(
  //                                 Icons.person,
  //                                 color: isDark
  //                                     ? AppColors.darkSurface
  //                                     : AppColors.primary,
  //                                 size: 30,
  //                               )
  //                             : null,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           const SizedBox(height: 32),
  //           // Divider Line
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0),
  //             child: Divider(color: dividerColor, height: 1, thickness: 1),
  //           ),
  //           const SizedBox(height: 32),

  //           // Menu Items
  //           _buildDrawerItem(
  //             icon: Icons.dashboard_rounded,
  //             label: 'Dashboard',
  //             itemBg: itemBg,
  //             textColor: textColor,
  //             onTap: () {
  //               Get.back();
  //               Get.toNamed(AppRoutes.dasboard);
  //             },
  //           ),
  //           const SizedBox(height: 20),
  //           _buildDrawerItem(
  //             icon: Icons.bar_chart_rounded,
  //             label: 'Task',
  //             itemBg: itemBg,
  //             textColor: textColor,
  //             onTap: () => Get.back(),
  //           ),
  //           const SizedBox(height: 20),
  //           _buildDrawerItem(
  //             icon: Icons.calendar_today_rounded,
  //             label: 'Calendar',
  //             itemBg: itemBg,
  //             textColor: textColor,
  //             onTap: () {
  //               Get.back();
  //               Get.toNamed(AppRoutes.calendar);
  //             },
  //           ),
  //           const SizedBox(height: 20),
  //           _buildDrawerItem(
  //             icon: Icons.settings_rounded,
  //             label: 'Setting',
  //             itemBg: itemBg,
  //             textColor: textColor,
  //             onTap: () {
  //               Get.back();
  //               Get.toNamed(AppRoutes.setting);
  //             },
  //           ),
  //           const SizedBox(height: 20),
  //           _buildDrawerItem(
  //             icon: Icons.upload_file_rounded,
  //             label: 'Upload Profile',
  //             itemBg: itemBg,
  //             textColor: textColor,
  //             onTap: () {
  //               Get.back();
  //               controller.uploadProfileImage();
  //             },
  //           ),
  //           const Spacer(),
  //           _buildDrawerItem(
  //             icon: Icons.logout_rounded,
  //             label: 'Logout',
  //             itemBg: itemBg,
  //             textColor: textColor,
  //             onTap: () {
  //               Get.back();
  //               Get.defaultDialog(
  //                 title: 'Logout',
  //                 titleStyle: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? AppColors.white : AppColors.black,
  //                 ),
  //                 backgroundColor: isDark
  //                     ? AppColors.darkSurface
  //                     : AppColors.lightSurface,
  //                 middleText: 'Are you sure you want to log out?',
  //                 middleTextStyle: TextStyle(
  //                   color: isDark ? AppColors.darkSubtitle : Colors.black87,
  //                 ),
  //                 textConfirm: 'Logout',
  //                 textCancel: 'Cancel',
  //                 confirmTextColor: Colors.white,
  //                 buttonColor: const Color(0xFFA62A22),
  //                 cancelTextColor: isDark
  //                     ? AppColors.darkSubtitle
  //                     : Colors.black54,
  //                 onConfirm: () {
  //                   Get.back();
  //                   controller.logout();
  //                 },
  //               );
  //             },
  //             isDestructive: true,
  //           ),
  //           const SizedBox(height: 30),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDrawerItem({
  //   required IconData icon,
  //   required String label,
  //   required Color itemBg,
  //   required Color textColor,
  //   required VoidCallback onTap,
  //   bool isDestructive = false,
  // }) {
  //   // Red color for logout, dynamic theme color for everything else
  //   final contentColor = isDestructive ? const Color(0xFFA62A22) : textColor;

  //   return Container(
  //     margin: const EdgeInsets.only(right: 56),
  //     child: Material(
  //       color: itemBg,
  //       borderRadius: const BorderRadius.only(
  //         topRight: Radius.circular(30),
  //         bottomRight: Radius.circular(30),
  //       ),
  //       child: InkWell(
  //         borderRadius: const BorderRadius.only(
  //           topRight: Radius.circular(30),
  //           bottomRight: Radius.circular(30),
  //         ),
  //         onTap: onTap,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  //           child: Row(
  //             children: [
  //               Icon(icon, color: contentColor, size: 24),
  //               const SizedBox(width: 16),
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   color: contentColor,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
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
      builder: (BuildContext context, BoxConstraints constraints) {
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
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }),
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

class ShimmerCard extends StatefulWidget {
  final bool isDark;
  const ShimmerCard({super.key, this.isDark = false});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: widget.isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      end: widget.isDark ? Colors.grey.shade700 : Colors.grey.shade300,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 18,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _colorAnimation.value,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 1.5,
                          height: 6,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: _colorAnimation.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorAnimation.value,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipPath(
                  clipper: TaskCardClipper(),
                  child: Container(
                    height: 135,
                    color: _colorAnimation.value,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

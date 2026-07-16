import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/services/task_services.dart';
import 'package:to_do_list/model/add_task_model.dart';
import 'package:to_do_list/core/constants/app_colors.dart'; // Import AppColors

part 'detail_task_binding.dart';
part 'detail_task_controller.dart';

class DetailTaskView extends GetView<DetailTaskViewController> {
  const DetailTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode[cite: 23]
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive colors
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAF9);
    final surfaceColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB);
    final primaryTextColor = isDark ? AppColors.white : const Color(0xFF1F2937);
    final secondaryTextColor = isDark ? AppColors.darkSubtitle : Colors.black45;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? AppColors.white : Colors.black87,
                size: 16,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: controller.goToEditTask,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final currentTask = controller.task.value;
        final dateStr = "${currentTask.dueDate.toLocal()}".split(' ')[0];

        // Format dynamic priority badge values[cite: 23]
        Color priorityColor = const Color(0xFFFFB100);
        if (currentTask.priority.toLowerCase() == 'low') {
          priorityColor = const Color(0xFF4CAF50);
        }
        if (currentTask.priority.toLowerCase() == 'high') {
          priorityColor = const Color(0xFFF44336);
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Status dynamic strip layout[cite: 23]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDynamicStatusBadge(
                            controller.currentStatus.value,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: priorityColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              "${currentTask.priority.toUpperCase()} PRIORITY",
                              style: TextStyle(
                                color: priorityColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Task Title[cite: 23]
                      Text(
                        currentTask.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Block Card Box Layout View[cite: 23]
                      Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          currentTask.description.isNotEmpty
                              ? currentTask.description
                              : 'No descriptive text provided for this task context item.',
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark
                                ? AppColors.darkText
                                : const Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Information Grid Cards[cite: 23]
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetaInfoCard(
                              icon: Icons.calendar_today_outlined,
                              title: 'Due Date',
                              subtitle: dateStr,
                              iconColor: AppColors.primary,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMetaInfoCard(
                              icon: currentTask.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              title: 'Preference',
                              subtitle: currentTask.isFavorite
                                  ? 'Starred Task'
                                  : 'Regular Task',
                              iconColor: currentTask.isFavorite
                                  ? Colors.redAccent
                                  : secondaryTextColor,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Interactive Task State Management Toggle System Row Header Label[cite: 23]
                      Text(
                        'Update Task Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Button Status Switcher Controller Block[cite: 23]
                      _buildInteractiveStatusSwitcher(isDark, surfaceColor),
                    ],
                  ),
                ),
              ),

              // Loading blocking overlay layout status sync row handler[cite: 23]
              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CupertinoActivityIndicator(color: AppColors.primary),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDynamicStatusBadge(String status) {
    Color badgeColor = const Color(0xFFFFB100); // Pending default[cite: 23]
    if (status == 'in_progress') badgeColor = const Color(0xFF2196F3);
    if (status == 'completed') badgeColor = AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMetaInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubtitle : Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.white : const Color(0xFF1F2937),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStatusSwitcher(bool isDark, Color surfaceColor) {
    final List<String> statuses = [
      'pending',
      'in_progress',
      'completed',
    ]; //[cite: 23]

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? surfaceColor : const Color(0xFFE5E7EB).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: statuses.map((status) {
          final isSelected = controller.currentStatus.value == status;

          Color activeBgColor = AppColors.primary; // Sage default[cite: 23]
          if (status == 'pending' && isSelected) {
            activeBgColor = const Color(0xFFFFB100);
          }
          if (status == 'in_progress' && isSelected) {
            activeBgColor = const Color(0xFF2196F3);
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.updateStatus(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? activeBgColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: activeBgColor.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  status.replaceAll('_', ' ').capitalizeFirst!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkSubtitle : Colors.black54),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

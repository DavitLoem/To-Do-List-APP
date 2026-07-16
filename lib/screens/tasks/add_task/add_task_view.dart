import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/services/task_services.dart';
import 'package:to_do_list/model/add_task_model.dart';
import 'package:to_do_list/core/constants/app_colors.dart'; // Add this import

part 'add_task_binding.dart';
part 'add_task_controller.dart';

class AddTaskView extends GetView<AddTaskViewController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Dark Mode Variables ---
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : const Color(0xFFF8FAF9);
    final surfaceColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB);
    final textColor = isDark ? AppColors.white : Colors.black87;
    final subTextColor = isDark ? AppColors.darkSubtitle : Colors.black54;
    // ---------------------------

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
                color: textColor,
                size: 16,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Obx(
          () => Text(
            controller.isUpdate.value ? 'Update Task' : 'Create Task',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title Input Field
                    _buildLabel('Task Title', subTextColor),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller.titleController,
                      'Task Title',
                      isDark,
                      surfaceColor,
                      borderColor,
                      textColor,
                    ),
                    const SizedBox(height: 20),

                    // Description Input Field
                    _buildLabel('Description', subTextColor),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller.descriptionController,
                      'Description',
                      isDark,
                      surfaceColor,
                      borderColor,
                      textColor,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),

                    // Priority Section Grid
                    _buildLabel('Priority', subTextColor),
                    const SizedBox(height: 8),
                    Row(
                      children: controller.priorityOptions
                          .map(
                            (p) => Expanded(
                              child: _buildPriorityChip(
                                p,
                                isDark,
                                surfaceColor,
                                borderColor,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // Due Date Interactive Picker Box Field
                    _buildLabel('Due Date', subTextColor),
                    const SizedBox(height: 8),
                    _buildDatePicker(
                      context,
                      isDark,
                      surfaceColor,
                      borderColor,
                      textColor,
                    ),
                    const SizedBox(height: 20),

                    // Favorite Inline Switch Card Component
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Obx(
                            () => Icon(
                              controller.isFavorite.value
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: controller.isFavorite.value
                                  ? Colors.redAccent
                                  : (isDark
                                        ? AppColors.darkSubtitle
                                        : Colors.black45),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Favorite',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          Obx(
                            () => CupertinoSwitch(
                              activeColor: AppColors.primary,
                              value: controller.isFavorite.value,
                              onChanged: (v) => controller.isFavorite.value = v,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Real-Time Live Preview Section
                    _buildLabel('Preview', subTextColor),
                    const SizedBox(height: 12),
                    _buildLivePreviewCard(),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Form Action Button Panel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitTask,
                    child: controller.isLoading.value
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                            controller.isUpdate.value
                                ? 'Update Task'
                                : 'Create Task',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) => Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color),
  );

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textColor, {
    int maxLines = 1,
  }) {
    final double radius = maxLines == 1 ? 28.0 : 20.0;

    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkSubtitle : Colors.black38,
          fontSize: 15,
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: AppColors.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(
    String p,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
  ) {
    Color dotColor;
    if (p == 'low') {
      dotColor = const Color(0xFF4CAF50);
    } else if (p == 'high') {
      dotColor = const Color(0xFFF44336);
    } else {
      dotColor = const Color(0xFFFFB100);
    }

    return Obx(() {
      final isSelected = controller.selectedPriority.value == p;
      return GestureDetector(
        onTap: () => controller.selectedPriority.value = p,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                p.capitalize!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSubtitle : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDatePicker(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textColor,
  ) => GestureDetector(
    onTap: () => controller.pickDate(context),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: isDark ? AppColors.darkSubtitle : Colors.black45,
            size: 20,
          ),
          const SizedBox(width: 12),
          Obx(() {
            final dateStr = "${controller.selectedDueDate.value.toLocal()}"
                .split(' ')[0];
            return Text(
              dateStr,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
          const Spacer(),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.darkBorder : Colors.black38,
          ),
        ],
      ),
    ),
  );

  Widget _buildLivePreviewCard() {
    return Obx(() {
      final title = controller.rxTitle.value.trim();
      final description = controller.rxDescription.value.trim();
      final dueDate = controller.selectedDueDate.value;

      const cardColor = Color(
        0xFF385A52,
      ); // Keep this dark green for the card brand
      const titleColor = Colors.white;
      const subColor = Color(0xFFA5D1B5);

      String topDay = dueDate.day.toString().padLeft(2, '0');
      String bottomDay = dueDate
          .add(const Duration(days: 3))
          .day
          .toString()
          .padLeft(2, '0');

      return Row(
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
                  style: const TextStyle(
                    color: cardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PreviewDashedLine(
                      direction: Axis.vertical,
                      dashHeight: 4,
                      dashWidth: 1.5,
                      color: cardColor.withOpacity(0.4),
                    ),
                  ),
                ),
                Text(
                  bottomDay,
                  style: const TextStyle(
                    color: cardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipPath(
              clipper: PreviewCardClipper(),
              child: Container(
                height: 135,
                color: cardColor,
                child: Stack(
                  children: [
                    Positioned(
                      top: 14,
                      left: 20,
                      child: Text(
                        controller.isUpdate.value
                            ? (controller
                                      .existingTask
                                      ?.status
                                      .capitalizeFirst ??
                                  'Pending')
                            : 'Pending',
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
                                child: const Icon(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title.isNotEmpty ? title : 'Task Title',
                                  style: const TextStyle(
                                    color: titleColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description.isNotEmpty
                                      ? description
                                      : 'No description yet...',
                                  style: const TextStyle(
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
                          const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white54,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class PreviewDashedLine extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final Color color;
  final Axis direction;

  const PreviewDashedLine({
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

class PreviewCardClipper extends CustomClipper<Path> {
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

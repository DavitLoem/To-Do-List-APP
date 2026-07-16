import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable circular back button used across auth/onboarding screens.
///
/// Extracted into its own widget so it can be reused anywhere a
/// white circular "back" control (matching the app's header style)
/// is needed, instead of being rebuilt inline on every screen.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.size = 40,
    this.iconColor = Colors.grey,
    this.backgroundColor = Colors.white,
  });

  /// Called when tapped. Defaults to `Get.back()` if not provided.
  final VoidCallback? onPressed;

  /// Diameter of the circular button.
  final double size;

  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: SizedBox(
        width: size,
        height: size,
        child: IconButton(
          padding: EdgeInsets.zero,
          splashRadius: size / 2,
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: iconColor,
            size: size * 0.42,
          ),
          onPressed: onPressed ?? () => Get.back(),
        ),
      ),
    );
  }
}

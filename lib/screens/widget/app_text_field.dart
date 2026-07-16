import 'package:flutter/material.dart';
import 'package:to_do_list/core/constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  /// Optional external controller.
  /// If provided, the caller is responsible for disposing it.
  /// If omitted, [AppTextField] creates and disposes its own controller.
  final TextEditingController? controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Color borderColor;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.borderColor = AppColors.fieldBorder,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it internally.
    // When an external controller is supplied, its owner disposes it.
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: widget.borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: widget.borderColor, width: 1.2),
        ),
      ),
    );
  }
}

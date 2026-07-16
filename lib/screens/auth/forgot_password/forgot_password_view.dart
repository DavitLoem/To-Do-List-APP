import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/core/constants/class_images.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/screens/widget/app_back_button.dart';
import 'package:to_do_list/screens/widget/app_text_field.dart';
import 'package:to_do_list/screens/widget/app_button.dart'; // Added import

part 'forgot_password_binding.dart';
part 'forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordViewController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // The TextEditingController is owned by the form widget so its lifecycle
    // is tied to the widget, not the GetX controller.
    return _ForgotPasswordForm(controller: controller);
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  final ForgotPasswordViewController controller;

  const _ForgotPasswordForm({required this.controller});

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header artwork (assets/header.png) with back button + title on top
            SizedBox(
              height: 820,
              child: Stack(
                clipBehavior: Clip.none,

                children: [
                  Image.asset(
                    AppImage.header,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  // Back button, pinned to the top-left corner
                  Positioned(
                    top: 28,
                    left: 16,
                    child: AppBackButton(onPressed: () => Get.back()),
                  ),
                  // Title, centered on the same row as the back button
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 140,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: Image.asset(
                            AppImage.forgotpassword,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _buildLabel('Email Address'),
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: _emailController,
                                hint: 'Enter Email Address',
                                keyboardType: TextInputType.emailAddress,
                                borderColor: AppColors
                                    .primary, // Retains your custom green border
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

            // Illustration below header

            // Form content below illustration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Obx(
                    () => AppButton(
                      text:
                          'Send Reset Link', // Changed text to make more sense contextually
                      onPressed: () => widget.controller.sendResetLink(
                        _emailController.text,
                      ),
                      isLoading: widget.controller.isLoading.value,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.primary, // Dark green label text
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

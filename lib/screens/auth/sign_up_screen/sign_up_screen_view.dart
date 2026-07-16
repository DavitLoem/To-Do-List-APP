import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/core/constants/class_images.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/screens/widget/app_text_field.dart';
import 'package:to_do_list/screens/widget/app_button.dart'; // Added import

part 'sign_up_screen_binding.dart';
part 'sign_up_screen_controller.dart';

class SignUpScreenView extends GetView<SignUpScreenViewController> {
  const SignUpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // The TextEditingControllers are owned by the form widget so their
    // lifecycle is tied to the widget, not the GetX controller.
    return _SignUpScreenForm(controller: controller);
  }
}

class _SignUpScreenForm extends StatefulWidget {
  final SignUpScreenViewController controller;

  const _SignUpScreenForm({required this.controller});

  @override
  State<_SignUpScreenForm> createState() => _SignUpScreenFormState();
}

class _SignUpScreenFormState extends State<_SignUpScreenForm> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _fullNameController,
                    hint: 'Enter Full Name',
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _emailController,
                    hint: 'Enter Email Address',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  Obx(
                    () => AppTextField(
                      controller: _passwordController,
                      hint: 'Enter Password',
                      obscureText: widget.controller.obscurePassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget.controller.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryLight,
                        ),
                        onPressed: widget.controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Confirm Password'),
                  const SizedBox(height: 8),
                  Obx(
                    () => AppTextField(
                      controller: _confirmPasswordController,
                      hint: 'Enter Confirm Password',
                      obscureText:
                          widget.controller.obscureConfirmPassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget.controller.obscureConfirmPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.primaryLight,
                        ),
                        onPressed:
                            widget.controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 66),

                  // Replaced with Custom Button
                  Obx(
                    () => AppButton(
                      text: 'Sign Up',
                      onPressed: () => widget.controller.signUp(
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      ),
                      isLoading: widget.controller.isLoading.value,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'Already Have An Account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back();
                              },
                          ),
                        ],
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          AppImage.header,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: skip navigation
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

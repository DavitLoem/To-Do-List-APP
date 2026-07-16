import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/api/services/auth_services.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/core/constants/class_images.dart';
import 'package:to_do_list/routes/app_page.dart';
import 'package:to_do_list/screens/widget/app_text_field.dart';
import 'package:to_do_list/screens/widget/app_button.dart'; // Added import

part 'sign_in_screen_binding.dart';
part 'sign_in_screen_controller.dart';

class SignInScreenView extends GetView<SignInScreenViewController> {
  const SignInScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // The TextEditingControllers are owned by the form widget so their
    // lifecycle is tied to the widget, not the GetX controller. This prevents
    // "TextEditingController used after being disposed" errors during navigation.
    return _SignInScreenForm(controller: controller);
  }
}

class _SignInScreenForm extends StatefulWidget {
  final SignInScreenViewController controller;

  const _SignInScreenForm({required this.controller});

  @override
  State<_SignInScreenForm> createState() => _SignInScreenFormState();
}

class _SignInScreenFormState extends State<_SignInScreenForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  const SizedBox(height: 28),
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Replaced with Custom Button
                  Obx(
                    () => AppButton(
                      text: 'Sign In',
                      onPressed: () => widget.controller.signIn(
                        email: _emailController.text,
                        password: _passwordController.text,
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
                          const TextSpan(text: 'Don\'t Have An Account? '),
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppRoutes.signUp);
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
                children: const [
                  Text(
                    'Welcome Back',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Sign In',
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

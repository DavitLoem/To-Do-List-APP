import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/constants/app_colors.dart';
import 'package:to_do_list/core/constants/class_images.dart';
import 'package:to_do_list/screens/auth/verify_otp_screen/verify_otp_screen_controller.dart';
import 'package:to_do_list/screens/widget/app_back_button.dart';
import 'package:to_do_list/screens/widget/app_button.dart';

part 'verify_otp_screen_binding.dart';

class VerifyOtpScreenView extends GetView<VerifyOtpScreenViewController> {
  const VerifyOtpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // The OTP TextEditingControllers and FocusNodes are owned by the form
    // widget so their lifecycle is tied to the widget, not the GetX controller.
    return _VerifyOtpForm(controller: controller);
  }
}

class _VerifyOtpForm extends StatefulWidget {
  final VerifyOtpScreenViewController controller;

  const _VerifyOtpForm({required this.controller});

  @override
  State<_VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<_VerifyOtpForm> {
  late final TextEditingController _c1;
  late final TextEditingController _c2;
  late final TextEditingController _c3;
  late final TextEditingController _c4;

  late final FocusNode _f1;
  late final FocusNode _f2;
  late final FocusNode _f3;
  late final FocusNode _f4;

  @override
  void initState() {
    super.initState();
    _c1 = TextEditingController();
    _c2 = TextEditingController();
    _c3 = TextEditingController();
    _c4 = TextEditingController();

    _f1 = FocusNode();
    _f2 = FocusNode();
    _f3 = FocusNode();
    _f4 = FocusNode();
  }

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();

    _f1.dispose();
    _f2.dispose();
    _f3.dispose();
    _f4.dispose();
    super.dispose();
  }

  String get _otp => _c1.text + _c2.text + _c3.text + _c4.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 810,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    AppImage.header,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 8,
                    left: 28,
                    child: AppBackButton(onPressed: () => Get.back()),
                  ),
                  const Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Verify OTP',
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
                    top: 36,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: Image.asset(
                            AppImage.verifyOtp,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Code has been send to\n',
                                    ),
                                    TextSpan(
                                      text: widget
                                          .controller
                                          .maskedEmail, // <-- Changed to maskedEmail
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              // 4-Digit OTP Input Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildOtpBox(_c1, _f1, _f2, context),
                                  _buildOtpBox(_c2, _f2, _f3, context),
                                  _buildOtpBox(_c3, _f3, _f4, context),
                                  _buildOtpBox(_c4, _f4, null, context),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Resend Timer
                              Obx(
                                () => GestureDetector(
                                  onTap:
                                      widget.controller.timerSeconds.value == 0
                                      ? widget.controller.resendOtp
                                      : null,
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              widget
                                                      .controller
                                                      .timerSeconds
                                                      .value ==
                                                  0
                                              ? 'Resend Code'
                                              : 'Resend Code In ',
                                        ),
                                        if (widget
                                                .controller
                                                .timerSeconds
                                                .value >
                                            0)
                                          TextSpan(
                                            text:
                                                '${widget.controller.timerSeconds.value} s',
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Obx(
                    () => AppButton(
                      text: 'Verify',
                      onPressed: () => widget.controller.verifyOtp(_otp),
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

  // Custom widget for individual OTP boxes
  Widget _buildOtpBox(
    TextEditingController c,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation: currentFocus,
      builder: (context, child) {
        final isFocused = currentFocus.hasFocus;
        return Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: isFocused ? AppColors.primary : AppColors.fieldBorder,
              width: isFocused ? 2.2 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              children: [
                TextField(
                  controller: c,
                  focusNode: currentFocus,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.transparent,
                    height: 1,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  buildCounter:
                      (
                        context, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) => const SizedBox.shrink(),
                  cursorColor: AppColors.primary,
                  onChanged: (value) {
                    if (value.isNotEmpty && nextFocus != null) {
                      FocusScope.of(context).requestFocus(nextFocus);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

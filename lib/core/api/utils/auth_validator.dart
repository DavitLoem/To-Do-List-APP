import 'package:get/get.dart';

class AuthValidator {
  // ១. ឆែកប្រអប់ឈ្មោះ (First Name / Last Name)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name cannot be empty";
    }
    return null; // អត់មាន Error
  }

  // ២. ឆែកប្រអប់ Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }
    if (!GetUtils.isEmail(value.trim())) {
      return "Please enter a valid email address";
    }
    return null;
  }

  // ៣. ឆែកប្រអប់លេខសម្ងាត់ (Password) សម្រាប់ Register / New Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  // ៤. ឆែកប្រអប់លេខសម្ងាត់ពេល Login (គ្រាន់តែឆែកកុំឱ្យទទេ)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }

  // ៥. ឆែកប្រអប់បញ្ជាក់លេខសម្ងាត់ (Confirm Password)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  static String? validateOTP({String? otpCode}) {
    if (otpCode == null || otpCode.isEmpty) {
      return "Please enter your OTP";
    }
    return null;
  }
}

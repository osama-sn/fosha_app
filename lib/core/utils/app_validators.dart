import 'package:easy_localization/easy_localization.dart';

class AppValidators {
  AppValidators._();

  static String _tr(String key, String fallbackAr, String fallbackEn) {
    try {
      final translated = key.tr();
      if (translated != key) return translated;
    } catch (_) {}
    return fallbackAr;
  }

  /// Validates required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      if (fieldName != null && fieldName.isNotEmpty) {
        return 'الرجاء إدخال $fieldName';
      }
      return _tr(
        'validation.required',
        'هذا الحقل مطلوب',
        'This field is required',
      );
    }
    return null;
  }

  /// Validates full name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _tr(
        'validation.nameRequired',
        'الرجاء إدخال الاسم بالكامل',
        'Please enter your full name',
      );
    }
    if (value.trim().length < 2) {
      return _tr(
        'validation.nameTooShort',
        'الاسم قصير جداً',
        'Name is too short',
      );
    }
    return null;
  }

  /// Validates email address format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _tr(
        'validation.emailRequired',
        'الرجاء إدخال البريد الإلكتروني',
        'Please enter your email',
      );
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value.trim())) {
      return _tr(
        'validation.invalidEmail',
        'البريد الإلكتروني غير صالح',
        'Invalid email address',
      );
    }
    return null;
  }

  /// Validates phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _tr(
        'validation.phoneRequired',
        'الرجاء إدخال رقم الهاتف',
        'Please enter your phone number',
      );
    }
    final phoneRegExp = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegExp.hasMatch(value.trim().replaceAll(' ', ''))) {
      return _tr(
        'validation.invalidPhone',
        'رقم الهاتف غير صالح',
        'Invalid phone number',
      );
    }
    return null;
  }

  /// Validates password with minimum length
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return _tr(
        'validation.passwordRequired',
        'الرجاء إدخال كلمة المرور',
        'Please enter your password',
      );
    }
    if (value.length < minLength) {
      return _tr(
        'validation.passwordLength',
        'كلمة المرور يجب أن لا تقل عن $minLength أحرف',
        'Password must be at least $minLength characters',
      );
    }
    return null;
  }

  /// Validates password confirmation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return _tr(
        'validation.confirmPasswordRequired',
        'الرجاء تأكيد كلمة المرور',
        'Please confirm your password',
      );
    }
    if (value != password) {
      return _tr(
        'validation.passwordMatch',
        'كلمات المرور غير متطابقة',
        'Passwords do not match',
      );
    }
    return null;
  }
}

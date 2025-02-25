import 'package:get/get.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';

abstract class AppValidator {
  String? validate(String? value);
}

// TEXT VALIDATOR
class TextValidator extends AppValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return LanguageConst.pleaseEnterField.tr;
    }
    return null;
  }
}

// EMAIL VALIDATOR
class EmailValidator extends AppValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LanguageConst.pleaseEnterYourEmail.tr;
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return LanguageConst.pleaseEnterValidEmail.tr;
    }
    if (!value.endsWith("@gmail.com")) {
      return LanguageConst.onlyAllowedEmailDomains.tr;
    }
    return null;
  }
}

// PASSWORD VALIDATOR
class PasswordValidator extends AppValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return LanguageConst.pleaseEnterPassword.tr;
    } else if (value.length < 8) {
      return LanguageConst.passwordMinLength.tr;
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return LanguageConst.passwordUppercaseRequired.tr;
    } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return LanguageConst.passwordLowercaseRequired.tr;
    } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return LanguageConst.passwordNumberRequired.tr;
    } else if (!RegExp(r'(?=.*[@\$!%*?&])').hasMatch(value)) {
      return LanguageConst.passwordSpecialCharRequired.tr;
    }
    return null;
  }
}

// USERNAME VALIDATOR
class UserNameValidator extends AppValidator {
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LanguageConst.pleaseEnterField.tr;
    }
    if (value.length < 3 || value.length > 30) {
      return "Username must be between 3 and 30 characters";
    }
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(value)) {
      return "Use only letters, numbers, periods, and underscores";
    }
    if (value.endsWith('.') || value.endsWith('_')) {
      return "Username can't end with a period or underscore";
    }
    return null;
  }
}

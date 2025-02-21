import 'package:get/get.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';

abstract class AppValidator {
  String? validator(String? value);
}

// TEXT VALIDATOR
class TextValidator extends AppValidator {
  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return LanguageConst.pleaseEtfield.tr;
    }
    return null;
  }
}

// EMAIL VALIDATOR
class EmailValidator extends AppValidator {
  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return LanguageConst.pleaseEYEmail.tr;
    } else if (value.endsWith("@gmail.com")) {
      return LanguageConst.pleaseEaValidEmail;
    }
    return null;
  }
}

// PASSWORD VALIDATOR
class PasswordValidator extends AppValidator {
  @override
  validator(String? value) {
    if (value == null || value.isEmpty) {
      return LanguageConst.pleaseEPassword;
    } else if (value.length < 6) {
      return LanguageConst.pleaseEatleast6CPassword;
    } else {
      return null;
    }
  }
}

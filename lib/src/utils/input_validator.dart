/*
 * ---------------------------
 * File : input_validator.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'reg_exp.dart';

class InputValidator {
  ///validate if text is valid phone number or not
  static bool phoneNumber(String text, [int length = 10]) {
    if (text.trim().length != length) {
      return false;
    }
    return true;
  }

  ///validate if text is valid tc(Turkey Republic identity number) or not
  static bool tcNumber(String text) {
    if (text.trim().length != 11) {
      return false;
    }
    if (text.trim().substring(0, 1) != '0') {
      int top = 0;
      for (int i = 0; i < 10; i++) {
        String val = text.trim().substring(i, i + 1);
        top = top + int.parse(val);
      }
      top = top % 10;
      if (top != int.parse(text.trim().substring(10))) {
        return false;
      }
    }
    return true;
  }

  ///validate if text is valid email or not
  static bool email(String text) {
    if (!RegExps.email().hasMatch(text)) {
      return false;
    }

    return true;
  }
}

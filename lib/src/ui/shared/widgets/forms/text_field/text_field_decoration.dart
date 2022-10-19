/*
 * ---------------------------
 * File : text_field_decoration.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

InputDecoration textFieldDecoration({
  String? hintText,
  Widget? leadingIcon,
  Widget? endingIcon,

// defaults
  double borderWidth = 1.0,
  double borderRadius = 8.0,
  Color borderColor = Colors.black,
  Color borderErrorColor = Colors.red,
  Color hintTextColor = Colors.grey,
  double hintFontSize = 16.0,
  Color fillColor = Colors.transparent,
}) {
  return InputDecoration(
    filled: true,
    fillColor: fillColor,
    hintText: hintText,
    hintStyle: TextStyle(
      color: hintTextColor,
      fontSize: hintFontSize,
    ),
    border: _border(borderColor, borderWidth, borderRadius),
    focusedBorder: _border(borderColor, borderWidth + 0.5, borderRadius),
    errorBorder: _border(borderErrorColor, borderWidth + 1, borderRadius),
    focusedErrorBorder: _border(
        borderErrorColor.withOpacity(0.8), borderWidth + .8, borderRadius),
    prefixIcon: leadingIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    suffixIcon: endingIcon,
  );
}

_border(Color borderColor, double borderWidth, double borderRadius) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );

/*
 * ---------------------------
 * File : form_decoration.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

import '../text_widget/text_size.dart';
import '../text_widget/text_widget.dart';

///default build counter
Widget buildCounter(
  BuildContext context, {
  required int currentLength,
  required int? maxLength,
  required bool isFocused,
}) =>
    TextWidget(
      (maxLength! - currentLength) >= 0
          ? (maxLength - currentLength).toString()
          : "0",
      color: Colors.grey,
    );

///default label widget
Widget labelWidget({String text = ''}) => Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: TextWidget(
        text,
        color: Colors.grey,
        textSize: TextSize.large,
      ),
    );

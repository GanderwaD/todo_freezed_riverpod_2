/*
 * ---------------------------
 * File : flat_button_widget.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import '../text_widget/text_size.dart';
import '../text_widget/text_widget.dart';

class FlatButtonWidget extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? fontColor;
  final double? fontSize;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderSide? borderSide;
  final double? borderRadius;

  const FlatButtonWidget({
    Key? key,
    this.text,
    this.onPressed,
    this.child,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.borderSide,
    this.borderRadius,
    this.fontColor,
    this.fontSize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding,
        backgroundColor: backgroundColor,
        side: borderSide ?? BorderSide.none,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
        ),
      ),
      onPressed: onPressed,
      child: child ??
          TextWidget(
            text ?? '',
            color: fontColor,
            textSize: TextSize.medium,
            textAlign: TextAlign.center,
          ),
    );
  }
}

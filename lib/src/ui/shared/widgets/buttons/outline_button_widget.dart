/*
 * ---------------------------
 * File : outline_button_widget.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import '../text_widget/text_size.dart';
import '../text_widget/text_widget.dart';

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({
    super.key,
    this.text,
    this.textColor,
    this.textSize,
    this.bgColor,
    this.borderSide,
    this.onPressed,
    this.borderRadius,
    this.child,
    this.textPadding,
    this.width,
    this.height,
    this.fontWeight,
  });

  final String? text;
  final Widget? child;
  final Color? textColor;
  final TextSize? textSize;
  final Color? bgColor;

  final BorderSide? borderSide;
  final double? borderRadius;
  final VoidCallback? onPressed;
  final EdgeInsets? textPadding;
  final FontWeight? fontWeight;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: bgColor,
          side: borderSide ?? BorderSide.none,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
          ),
        ),
        child: Padding(
          padding: textPadding ?? EdgeInsets.zero,
          child: child ??
              TextWidget(
                text ?? '',
                color: textColor,
                textSize: textSize ?? TextSize.medium,
                textAlign: TextAlign.center,
                fontWeight: fontWeight ?? FontWeight.normal,
              ),
        ),
      ),
    );
  }
}

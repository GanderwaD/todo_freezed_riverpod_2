/*
 * ---------------------------
 * File : raised_button_widget.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import '../text_widget/text_size.dart';
import '../text_widget/text_widget.dart';

class RaisedButtonWidget extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? fontColor;
  final double? fontSize;
  final Color? bgColor;
  final String? fontFamily;
  final double? borderRadius;
  final BorderSide? borderSide;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsets? buttonPadding;

  const RaisedButtonWidget({
    Key? key,
    this.text,
    this.fontColor,
    this.fontSize,
    this.bgColor,
    this.fontFamily,
    this.borderRadius,
    this.borderSide,
    this.onPressed,
    this.child,
    this.width ,
    this.height ,
    this.buttonPadding ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: buttonPadding,
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
                fontFamily: fontFamily,
                textAlign: TextAlign.center,
              )),
    );
  }
}

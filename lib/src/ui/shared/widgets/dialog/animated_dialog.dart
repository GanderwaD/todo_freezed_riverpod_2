/*
 * ---------------------------
 * File : animated_dialog.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

import '../../../../router/router_delegate.dart';
import 'alert_widget.dart';
import 'dialog_animation.dart';

enum AnimationType {
  scale,
  rotate,
  slideInDown,
  slideInUp,
  slideInLeft,
  slideInRight,
}

Future animatedDialog({
  Widget title = const SizedBox.shrink(),
  required Widget content,
  Widget buttons = const SizedBox.shrink(),
  AnimationType animType = AnimationType.scale,
  bool dismissible = true,
  double borderRadius = 12.0,
  Color? backgroundColor = Colors.white,
}) async {
  BuildContext? context = appNavigatorKey.currentContext;
  if (context == null) {
    return Future.value(false);
  }

  Widget child = AlertDialog(
    backgroundColor: backgroundColor,
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    content: AlertWidget(
      title: title,
      content: content,
      buttons: buttons,
    ),
  );

  return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (con1, anim1, anim2, widget) {
        switch (animType) {
          case AnimationType.scale:
            return scaleAnimation(child: child, animation: anim1);
          case AnimationType.rotate:
            return rotateAnimation(child: child, animation: anim1);
          case AnimationType.slideInDown:
            return slideInDownAnimation(child: child, animation: anim1);
          case AnimationType.slideInUp:
            return slideInUpAnimation(child: child, animation: anim1);
          case AnimationType.slideInLeft:
            return slideInLeftAnimation(child: child, animation: anim1);
          case AnimationType.slideInRight:
            return slideInRightAnimation(child: child, animation: anim1);
          default:
            return child;
        }
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: dismissible,
      barrierLabel: '',
      context: context,
      pageBuilder: ((con1, anim1, anim2) => const SizedBox.shrink()));
}

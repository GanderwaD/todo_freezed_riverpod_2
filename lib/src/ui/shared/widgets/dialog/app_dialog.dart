/*
 * ---------------------------
 * File : app_dialog.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

import '../../../../router/router_delegate.dart';
import '../../../../router/router_helper.dart';
import '../buttons/flat_button_widget.dart';
import '../buttons/raised_button_widget.dart';
import '../text_widget/text_size.dart';
import '../text_widget/text_widget.dart';
import 'animated_dialog.dart';

appDialog(
  String message, {
  String? title,
  bool dismissible = true,
  VoidCallback? onClickConfirm,
  String? confirmBtn,
  String? cancelBtn,
  VoidCallback? onClickCancel,
  Widget? customBottomButtons,
}) async {
  BuildContext? context = appNavigatorKey.currentContext;
  if (context == null) {
    return Future.value(false);
  }

  R.instance.updateBarrierState(dismissible);

  Widget buttons = customBottomButtons ??
      Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cancelBtn == null
                ? const SizedBox.shrink()
                : Expanded(
                    child: FlatButtonWidget(
                    borderRadius: 10.0,
                    fontColor: Colors.grey,
                    text: cancelBtn,
                    onPressed:
                        onClickCancel ?? () => R.instance.popWidget(context),
                  )),
            confirmBtn == null
                ? const SizedBox.shrink()
                : Expanded(
                    child: RaisedButtonWidget(
                      bgColor: Colors.lightBlueAccent,
                      height: 40,
                      borderRadius: 10.0,
                      fontColor: Colors.white,
                      text: confirmBtn,
                      onPressed:
                          onClickConfirm ?? () => R.instance.popWidget(context),
                    ),
                  ),
          ],
        ),
      );

  await animatedDialog(
    content: TextWidget(
      message,
      textAlign: TextAlign.center,
      color: Colors.black,
    ),
    title: title != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextWidget(
              title,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              textSize: TextSize.large,
              color: Colors.black,
            ),
          )
        : const SizedBox.shrink(),
    buttons: buttons,
    dismissible: dismissible,
  );
}

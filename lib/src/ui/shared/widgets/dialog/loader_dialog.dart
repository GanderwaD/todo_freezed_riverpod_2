/*
 * ---------------------------
 * File : loader_dialog.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

import '../../../../router/router_delegate.dart';
import '../../../../router/router_helper.dart';

stopLoadingDialog() {
  R.instance.popWidget();
}

startLoadingDialog({
  Color bgColor = Colors.transparent,
}) {
  BuildContext? context = appNavigatorKey.currentContext;
  if (context == null) {
    return Future.value(false);
  }
  showGeneralDialog(
    context: context,
    barrierLabel: "loaderDialog",
    barrierDismissible: false,
    barrierColor: bgColor,
    pageBuilder: (_, __, ___) {
      return const Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    },
  );
}

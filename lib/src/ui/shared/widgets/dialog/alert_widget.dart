/*
 * ---------------------------
 * File : alert_widget.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';


class AlertWidget extends StatelessWidget {
  const AlertWidget({
    Key? key,
    this.title = const SizedBox.shrink(),
    required this.content,
    this.buttons = const SizedBox.shrink(),
  }) : super(key: key);

  final Widget title;
  final Widget content;
  final Widget buttons;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            title,
            const SizedBox(
              height: 5.0,
            ),
            content,
            const SizedBox(
              height: 10.0,
            ),
            buttons
          ],
        ),
      ),
    );
  }
}
















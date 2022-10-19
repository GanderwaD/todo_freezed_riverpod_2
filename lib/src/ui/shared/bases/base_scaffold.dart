/*
 * ---------------------------
 * File : base_scaffold.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import '../../../utils/keyboard_util.dart';
import '../widgets/text_widget/text_size.dart';
import '../widgets/text_widget/text_widget.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.appBarTitle,
    this.showBackButton = true,
    this.titleColor = Colors.black,
    this.titleSize = TextSize.large,
    this.drawer
  });
  final Widget body;
  final AppBar? appBar;
  final String? appBarTitle;
  final bool showBackButton;
  final Color titleColor;
  final TextSize titleSize;
  final Drawer? drawer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(),
      child: Scaffold(
        appBar: appBar ?? (appBarTitle == null ? null : AppBar(
          title: TextWidget(appBarTitle!,color: titleColor,textSize: titleSize,),
          automaticallyImplyLeading: showBackButton,
        )),
        drawer: drawer,
        body: body,
      ),
    );
  }
}

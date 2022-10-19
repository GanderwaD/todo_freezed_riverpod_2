/*
 * ---------------------------
 * File : text_widget.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

import 'default_text_widget_tags.dart';
import 'text_size.dart';




class TextWidget extends StatelessWidget {
  final String styledText;
  final Map<String, StyledTextTagBase> customTag;
  final Color? color;
  final String? fontFamily;
  final TextSize? textSize;
  final TextAlign textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextOverflow overflow;

  const TextWidget(
    this.styledText, {
    Key? key,
    this.customTag = const {},
    this.color = Colors.black,
    this.fontFamily,
    this.textSize = TextSize.medium,
    this.textAlign = TextAlign.start,
    this.maxLines = 999,
    this.fontWeight = FontWeight.normal,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: styledText,
      tags: {...defaultTextWidgetTags, ...customTag},
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      textScaleFactor: 1.0,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        fontSize: textSize?.size,
      ),
    );
  }
}




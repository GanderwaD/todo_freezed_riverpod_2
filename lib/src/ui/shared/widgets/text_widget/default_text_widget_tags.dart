/*
 * ---------------------------
 * File : default_text_widget_tags.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */



import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

/// text: 'Text with custom <color text="#ff5500">color</color> text.',
///text: 'Text with <link href="https://flutter.dev">link</link> inside.',// mostly custom
Map<String, StyledTextTagBase> defaultTextWidgetTags = {
  'b':
      StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)), //bold
  'l': StyledTextTag(style: const TextStyle(fontSize: 40.0)), //large
  'i': StyledTextTag(
      style: const TextStyle(fontStyle: FontStyle.italic)), //italic
  'color': StyledTextCustomTag(
      baseStyle: const TextStyle(fontStyle: FontStyle.normal),
      parse: (baseStyle, attributes) {
        if (attributes.containsKey('text') &&
            (attributes['text']!.substring(0, 1) == '#') &&
            attributes['text']!.length >= 6) {
          final String hexColor = attributes['text']!.substring(1);
          final String alphaChannel =
              (hexColor.length == 8) ? hexColor.substring(6, 8) : 'FF';
          final Color color =
              Color(int.parse('0x$alphaChannel${hexColor.substring(0, 6)}'));
          return baseStyle!.copyWith(color: color);
        } else {
          return baseStyle;
        }
      }),
};
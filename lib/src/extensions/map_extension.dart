/*
 * ---------------------------
 * File : extension_map.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'dart:convert';

extension ExtensionMap on Map {
  String get toJson => json.encode(this);
}

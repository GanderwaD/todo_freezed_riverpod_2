/*
 * ---------------------------
 * File : list_extension.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */
extension NullListExtension on List? {
  bool get isNullOrEmpty => this != null ? this!.isEmpty : true;
  bool get isNotNullOrEmpty => this != null ? this!.isNotEmpty : false;
}
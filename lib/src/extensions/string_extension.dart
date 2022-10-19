/*
 * ---------------------------
 * File : string_extension.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import '../localization/helper/localization_helper.dart';

extension StringExtension on String {
   String get italic {
    return "<i>${this}</i>";
  }
  
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpper}${substring(1)}' : '';

  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized)
      .join(" ");

  String get toUpper => toUpperTurkish.toUpperCase();
  String get toLower => toLowerTurkish.toLowerCase();
 
  String get toUpperTurkish => !appLocale.languageCode.contains('tr')
      ? this
      : replaceAll("i", "İ")
          .replaceAll("ö", "Ö")
          .replaceAll("ü", "Ü")
          .replaceAll("ş", "Ş")
          .replaceAll("ç", "Ç")
          .replaceAll("ğ", "Ğ");

  String get toLowerTurkish => !appLocale.languageCode.contains('tr')
      ? this
      : replaceAll("İ", "i")
          .replaceAll("Ö", "ö")
          .replaceAll("Ü", "ü")
          .replaceAll("Ş", "ş")
          .replaceAll("Ç", "ç")
          .replaceAll("Ğ", "ğ"); 
}

extension NullStringExtension on String? {
  bool get isNullOrEmpty => this != null ? this!.isEmpty : true;
  bool get isNotNullOrEmpty => this != null ? this!.isNotEmpty : false;
}

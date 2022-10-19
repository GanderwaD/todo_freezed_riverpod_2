/*
 * ---------------------------
 * File : language.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'dart:convert';

import 'package:flutter/material.dart';

import 'currency.dart';
import 'localization_helper.dart';

class Language {
  final int id;
  final String name;
  final String imagePath;
  final String urlCode;
  final Locale locale;
  final Currency currency;
  const Language({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.urlCode,
    required this.locale,
    required this.currency,
  });
  

  Language copyWith({
    int? id,
    String? name,
    String? imagePath,
    String? urlCode,
    Locale? locale,
    Currency? currency,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      urlCode: urlCode ?? this.urlCode,
      locale: locale ?? this.locale,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'urlCode': urlCode,
      'locale': locale.languageCode,
      'currency': currency.toMap(),
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      id: map['id'] as int,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      urlCode: map['urlCode'] as String,
      locale: Locale(map['locale'] ?? supportedLanguages.first.locale.languageCode),
      currency: Currency.fromMap(map['currency'] ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) => Language.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Language(id: $id, name: $name, imagePath: $imagePath, urlCode: $urlCode, locale: $locale, currency: $currency)';
  }

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.imagePath == imagePath &&
      other.urlCode == urlCode &&
      other.locale == locale &&
      other.currency == currency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      imagePath.hashCode ^
      urlCode.hashCode ^
      locale.hashCode ^
      currency.hashCode;
  }
}

/*
 * ---------------------------
 * File : english.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */



import 'package:flutter/material.dart';

import '../currency.dart';
import '../language.dart';

const english = Language(
  id: 2,
  name: 'English',
  imagePath: '/en_US.png',
  urlCode: 'en',
  locale: Locale('en', 'US'),
  currency: englishCurrency,
);

const englishCurrency = Currency(
  code: 840,
  name: 'US Dollar',
  shortName: 'USD',
  symbol: '\$',
);
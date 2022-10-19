/*
 * ---------------------------
 * File : turkish.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

import '../currency.dart';
import '../language.dart';

const turkish = Language(
  id: 2,
  name: 'Türkçe',
  imagePath: '/tr_TR.png',
  urlCode: 'tr',
  locale: Locale('tr', 'TR'),
  currency: turkishCurrency,
);

const turkishCurrency = Currency(
  code: 949,
  name: 'Türk Lirası',
  shortName: 'TRY',
  symbol: '₺',
);

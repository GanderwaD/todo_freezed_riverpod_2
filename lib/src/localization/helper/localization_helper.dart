/*
 * ---------------------------
 * File : localization_helper.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../router/router_delegate.dart';
import 'language.dart';
import 'languages/english.dart';

final Locale appLocale = Localizations.localeOf(appNavigatorKey.currentContext!);

AppLocalizations get tr =>
    AppLocalizations.of(appNavigatorKey.currentContext!)!;

const List<Language> supportedLanguages = [
  english
];

final List<Locale> supportedLocales = [
  english.locale,
];

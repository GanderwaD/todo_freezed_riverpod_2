/*
 * ---------------------------
 * File : dark_theme.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import 'colors.dart';



ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
 colorScheme:const ColorScheme.dark(
    primary: glaucous,
    secondary: lightSteelBlue,
  ) 
);


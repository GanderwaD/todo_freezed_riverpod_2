/*
 * ---------------------------
 * File : light_theme.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import 'colors.dart';


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme:const ColorScheme.light(
    primary: glaucous,
    secondary: lightSteelBlue,
  ) 

);



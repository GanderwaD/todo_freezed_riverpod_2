/*
 * ---------------------------
 * File : keyboard_util.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */



import 'package:flutter/material.dart';

///hide keyboard by un focusing 
void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
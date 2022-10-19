/*
 * ---------------------------
 * File : base_change_notifier.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';

class BaseChangeNotifier extends ChangeNotifier {
  bool loadingView = false;
  bool _disposed = false;
  BaseChangeNotifier() {
    initialize();
  }

  initialize() {}

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void toggleLoadingView() {
    loadingView = !loadingView;
    notifyListeners();
  }
}

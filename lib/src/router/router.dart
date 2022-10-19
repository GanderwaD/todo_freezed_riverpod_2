import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'back_button_dispatcher.dart';
import 'default_view.dart';
import 'router_action.dart';
import 'router_delegate.dart';
import 'router_helper.dart';
import 'router_parser.dart';

final routerProvider = ChangeNotifierProvider.family<AppRouter, WidgetRef>(
  (ref, widgetRef) {
    return AppRouter(widgetRef);
  },
);

class AppRouter extends ChangeNotifier {
  late AppBackButtonDispatcher backButtonDispatcher;
  late AppRouterDelegate delegate;
  late AppRouterParser parser;
  late RouterAction _currentAction;

   bool barrierDismissible = true;

  AppRouter(WidgetRef ref) {
    R.instance.ref = ref;
  
    _currentAction = RouterAction(
        object: const DefaultView(), 
        actionType: ActionType.replaceAll); 
        //default first page
    delegate = AppRouterDelegate(ref);
    parser = AppRouterParser();
    backButtonDispatcher = AppBackButtonDispatcher(delegate);
  }
  void resetCurrentAction() {
    _currentAction = RouterAction();
  }
  

  RouterAction get currentAction => _currentAction;
  set currentAction(RouterAction action) {
    _currentAction = action;
    notifyListeners();
  }

   ///carefully it disables android back button
  updateBarrierState(bool dismissible) {
    barrierDismissible = dismissible;
    notifyListeners();
  }
}



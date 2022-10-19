/*
 * ---------------------------
 * File : router_delegate.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'router_action.dart';
import 'router_helper.dart';

//global navigation state use it carefully!!
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppRouterDelegate extends RouterDelegate<RouterAction>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouterAction> {
  final WidgetRef ref;
  final List<MaterialPage> _pages = [];
  bool showingExit = false;

  @override
  GlobalKey<NavigatorState> navigatorKey = appNavigatorKey;

  AppRouterDelegate(this.ref);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      observers: const [],
      pages: buildPages(),
    );
  }

  ///navigator pop page
  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    return _remove(result);
  }

    ///back button 
  @override
  Future<bool> popRoute() {
    if (_remove(null)) {
      notifyListeners();
      return Future.value(true);
    }

    if (ref.read(routerProvider(ref)).barrierDismissible &&
      Navigator.canPop(appNavigatorKey.currentContext!)) {
      R.instance.popWidget(appNavigatorKey.currentContext!);
      return Future.value(true);
    }

    return _confirmAppExit();
  }

  Future<bool> _confirmAppExit() {
    if (!showingExit) {
      showingExit = true;
      // appDialog(
      //   tr.closeApp,
      //   title: tr.appTitle,
      //   confirmBtn: tr.yes,
      //   cancelBtn: tr.no,
      //   onClickConfirm: () => SystemNavigator.pop(),
      //   dismissible: false,
      //   onClickCancel: () {
      //     showingExit = false;
      //     R().popWidget(appNavigatorKey.currentContext!);
      //   },
      // );
    }

    return Future.value(true);
  }
  

 @override
  Future<void> setNewRoutePath(RouterAction configuration) {
    _pages.clear();
    _add(configuration);

    return SynchronousFuture(null);
  }

  List<Page> buildPages() {
    final RouterAction routerAction =
        ref.read(routerProvider(ref)).currentAction;

    switch (routerAction.actionType) {
      case ActionType.none:
        break;
      case ActionType.add:
        _add(routerAction);
        break;
      case ActionType.remove:
        _remove(routerAction.arguments);
        break;
      case ActionType.replace:
        _replace(routerAction);
        break;
      case ActionType.replaceAll:
        _replaceAll(routerAction);
        break;
    }
    ref.read(routerProvider(ref)).resetCurrentAction();
    return List.of(_pages);
  }


   void _add(RouterAction routerAction) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as RouterAction).object!.routeKey !=
            routerAction.object!.routeKey;
    if (shouldAddPage) {
      _pages.add(
        _createPage(routerAction),
      );
    }
  }
  bool _remove(arguments) {
    if (_pages.isNotEmpty && _pages.length > 1) {
      // do something with not null arguments
      (_pages.last.arguments as RouterAction).object?.onGoingBack();
      _pages.removeLast();
      return true;
    } else {
      return false;
    }
  }


  void _replace(RouterAction routerAction) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    _add(routerAction);
  }

  void _replaceAll(RouterAction routerAction) {
    setNewRoutePath(routerAction);
  }

  MaterialPage _createPage(RouterAction routerAction) {
    return MaterialPage(
      child: routerAction.object as Widget,
      key: Key(routerAction.object?.routeKey ?? '') as LocalKey,
      name: routerAction.object?.routePath,
      arguments: routerAction,
    );
  }
}

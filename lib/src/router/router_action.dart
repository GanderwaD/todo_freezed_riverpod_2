/*
 * ---------------------------
 * File : router_action.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'router_object.dart';

enum ActionType { none, add, remove, replace, replaceAll }

class RouterAction {
  ActionType actionType;
  RouterObject? object;
  Map<String, dynamic>? arguments;
  RouterAction({
    this.actionType = ActionType.none,
    this.object,
    this.arguments,
  }) {
    if (object == null) {
      actionType = ActionType.none;
    }
  }

  @override
  String toString() =>
      'RouterAction(type: $actionType, object: $object, arguments: $arguments)';
}

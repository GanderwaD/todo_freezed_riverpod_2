/*
 * ---------------------------
 * File : router_parser.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import 'default_view.dart';
import 'router_action.dart';

class AppRouterParser extends RouteInformationParser<RouterAction> {
  @override
  Future<RouterAction> parseRouteInformation(
      RouteInformation routeInformation) async {
    //final uri = Uri.parse(routeInformation.location ?? '');
    //if web platform is configured and deep linking configured 
    return RouterAction(object: const DefaultView());
  }
}

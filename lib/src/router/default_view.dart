/*
 * ---------------------------
 * File : default_view.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */


import 'package:flutter/material.dart';

import 'router_constants.dart';
import 'router_object.dart';


class DefaultView extends StatelessWidget with RouterObject {
  const DefaultView({super.key});
    
  @override
  String get routeKey => defaultKey;
  
  @override
  String get routePath => defaultPath;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DefaultView'),
      ),
      body: const Center(
        child: Text('DefaultView'),
      ),
    );
  }
  

}
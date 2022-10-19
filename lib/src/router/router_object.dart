/*
 * ---------------------------
 * File : router_object.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */



abstract class RouterObject {
  String get routeKey;
  String get routePath;
  bool get guard => false;
  onGoingBack() {}
}

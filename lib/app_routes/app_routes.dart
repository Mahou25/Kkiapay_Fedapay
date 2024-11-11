import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../Screens/Fedapay/fedapay.dart';
import '../Screens/Kkiapay/kkiapay.dart';

class AppRoutes {
  static const String fedapay = '/fedapay';
  static const String kkiapay = '/kkiapay';
  static Map<String, WidgetBuilder> routes = {
    kkiapay : (context) => Kkiapay(),
    fedapay : (context) => Fedapay(),
  };
}

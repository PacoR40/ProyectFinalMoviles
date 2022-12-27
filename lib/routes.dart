import 'package:flutter/material.dart';

import 'screens/notification_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/notification': (_) => notificationScreen(),
  };

  static String initial = '/notification';
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
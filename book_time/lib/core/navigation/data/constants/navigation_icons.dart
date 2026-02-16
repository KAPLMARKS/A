import 'package:flutter/material.dart';

class NavigationIcons {
  NavigationIcons._();

  static const IconData home = Icons.home;
  static const IconData tasks = Icons.check_circle_outline;
  static const IconData profile = Icons.person;
  
  static IconData getIconByRoute(String route) {
    switch (route) {
      case '/home':
        return home;
      case '/tasks':
        return tasks;
      case '/profile':
        return profile;
      default:
        return home;
    }
  }
}


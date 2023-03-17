import 'package:flutter/material.dart';

class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static List<String> _screenHistory = [];

  static void pushScreen(Widget screen) {
    // Check if the screen to be pushed is the same as the previous one
    final lastScreen = _screenHistory.isNotEmpty ? _screenHistory.last : null;
    final newScreen = screen.runtimeType.toString();
    if (lastScreen == newScreen) {
      // Remove the previous screen from the history and pop it
      _screenHistory.removeLast();
      navigatorKey.currentState?.pop();
    }

    // Add the new screen to the history and push it
    _screenHistory.add(newScreen);
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => screen));
  }

  static void pop() {
    if (_screenHistory.isNotEmpty) {
      // Remove the current screen from the history and pop it
      _screenHistory.removeLast();
      navigatorKey.currentState?.pop();
    }
  }
}
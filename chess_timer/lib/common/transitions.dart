import 'package:flutter/material.dart';

class Transitions {
  static Route fadeIn(newPage, {settings}) {
    assert(newPage != null);
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => newPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          );
        });
  }
}

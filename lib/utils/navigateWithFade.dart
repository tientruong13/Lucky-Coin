import 'package:flutter/material.dart';

Future<void> navigateWithFade(BuildContext context, Widget widget) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final opacityTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return FadeTransition(opacity: opacityTween, child: child);
      },
    ),
  );
}

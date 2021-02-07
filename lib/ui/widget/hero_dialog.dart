import 'package:flutter/material.dart';

class HeroDialog<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color barrierColor;

  HeroDialog({
    this.barrierDismissible = true,
    this.barrierColor = Colors.black54,
    this.builder,
  }) : super();

  @override
  bool get opaque => false;

  @override
  String get barrierLabel => null;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
      opacity: new CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

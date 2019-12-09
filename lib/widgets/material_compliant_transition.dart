import 'package:flutter/material.dart';

Widget materialCompliantTransitionBuilder(
    Widget w, Animation<double> animation, Widget current) {
  if (w != current) return FadeTransition(opacity: animation, child: w);
  return SizedBox.expand(
    child: Center(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
          child: w,
        ),
      ),
    ),
  );
}

class MaterialAnimatedSwitcher extends StatelessWidget {
  MaterialAnimatedSwitcher({@required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        switchInCurve: Curves.fastOutSlowIn,
        transitionBuilder: (w, a) =>
            materialCompliantTransitionBuilder(w, a, child),
        child: child);
  }
}

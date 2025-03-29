import 'package:flutter/material.dart';

class GestureSidebar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget child;

  const GestureSidebar({
    Key? key,
    required this.scaffoldKey,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          scaffoldKey.currentState?.openDrawer();
        }
      },
      child: child,
    );
  }
}
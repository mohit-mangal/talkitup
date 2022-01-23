import 'package:flutter/material.dart';

class RightSideSheet extends StatelessWidget {
  static display(
    BuildContext context, {
    BoxDecoration? sheetDecoration,
    required Widget child,
  }) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return RightSideSheet(child, sheetDecoration);
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(animation1),
          child: child,
        );
      },
    );
  }

  final Widget child;
  final Decoration? sheetDecoration;
  const RightSideSheet(this.child, this.sheetDecoration);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: sheetDecoration ??
              const BoxDecoration(
                color: Colors.black87,
                border: Border(
                  left: const BorderSide(color: Colors.white54),
                  top: const BorderSide(color: Colors.white24),
                ),
              ),
          child: child,
        ),
      ),
    );
  }
}

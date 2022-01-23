import 'package:flutter/material.dart';

class BgGradient extends StatelessWidget {
  final Widget? child;
  final Color bgColor;
  late Color foreBgColor;
  BgGradient({
    this.child,
    this.bgColor = Colors.white,
    Color? foregroundColor,
  }) {
    foreBgColor = foregroundColor ?? Colors.black.withOpacity(0.65);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Colors.pinkAccent,
              Colors.black87,
              Colors.black87,
              Colors.black54,
              Colors.redAccent,
            ],
            startAngle: 1,
          ),
        ),
        child: Container(
          color: foreBgColor,
          child: child,
        ),
      ),
    );
  }
}

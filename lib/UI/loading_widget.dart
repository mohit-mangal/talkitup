import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:talkitup/UI/bg_gradient.dart';

class LoadingWidget extends StatelessWidget {
  final bool withScaffold;
  LoadingWidget({this.withScaffold = false});
  @override
  Widget build(BuildContext context) {
    const spinkit = SpinKitSpinningLines(
      color: Colors.white,
      size: 96,
      lineWidth: 2,
      itemCount: 10,
    );
    final withGradient = BgGradient(
      child: spinkit,
      foregroundColor: Colors.transparent,
      bgColor: Colors.black26,
    );

    if (withScaffold) {
      return Scaffold(
        body: withGradient,
      );
    }

    return withGradient;
  }
}

import 'package:flutter/material.dart';

class NoScalingAnimation extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({required Offset begin, required Offset end, required double progress}) {
    return end;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {

    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {

    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}

Size calcTextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
  )..layout();
  return textPainter.size;
}

roundBefore(number) {
  return (number ~/ 100) * 100;
}

String shortAddressAsNickname(address) {
  return '${address.toString().substring(0, 6)}...'
      '${address.toString().substring(address.toString().length - 4)}';
}
//
// class InvalidDataException implements Exception {
//   final String code;
//   InvalidDataException(this.code);
// }
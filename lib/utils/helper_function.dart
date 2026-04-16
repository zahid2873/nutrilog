import 'package:flutter/material.dart';

class HelperFunction {
  static Color colorWithOpacity(Color color, double opacity) {
    return color.withValues(
      red: color.r,
      green: color.g,
      blue: color.b,
      alpha: opacity,
    );
  }
}

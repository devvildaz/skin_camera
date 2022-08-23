import 'package:flutter/material.dart' show MaterialColor;
import 'package:flutter/widgets.dart';

class AppColors {
  static const _baseIcedCantaloupe = 0xFFff9e9e;

  static const MaterialColor icedCantaloupe = MaterialColor(
    _baseIcedCantaloupe,
    <int, Color>{
      50: Color(0xFFffd9d9),
      100: Color(0xFFfcc7c7),
      200: Color(0xFFfcb3b3),
      400: Color(0xFFff9e9e),
      500: Color(0xFFfa9d9d),
      600: Color(0xFFfa8c8c),
      700: Color(0xFFfc8383),
      800: Color(0xFFfc7272),
      900: Color(0xFFe66363)
    }
  );
}
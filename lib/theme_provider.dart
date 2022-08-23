import 'package:flutter/material.dart';
import 'package:skin_camera/constants/app_colors.dart';

class ThemeProvider extends InheritedWidget {
  const ThemeProvider({ Key? key, required Widget child }) :
      super(key: key, child: child);

  static ThemeProvider? of(BuildContext context) {
    var target = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    return target;
  }

  ThemeData themeData(ThemeData theme) {
    debugPrint("themeData");
    return ThemeData(
      primarySwatch: Colors.red,
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }}
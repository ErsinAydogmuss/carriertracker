import 'package:flutter/material.dart';

class AppColor extends Color{
  static int _convertColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  AppColor(final String hexColor) : super(_convertColor(hexColor));
}
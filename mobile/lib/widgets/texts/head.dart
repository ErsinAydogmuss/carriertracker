import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/constants.dart';

class Head extends StatelessWidget {
  final String text;
  final Size size;
  final Color color;
  final IconData? icon;
  final MainAxisAlignment? mainAxisAlignment;

  const Head({
    super.key,
    required this.text,
    required this.size,
    required this.color,
    this.icon,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: size == Size.xSmall
                ? 15
                : size == Size.small
                ? 20
                : size == Size.medium
                ? 25
                : size == Size.large
                ? 35
                : 40,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inconsolata(
              textStyle: TextStyle(
                color: color,
                fontSize: getFontSize(size),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }else {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.inconsolata(
          textStyle: TextStyle(
            color: color,
            fontSize: getFontSize(size),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}

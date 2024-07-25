import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/constants.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final Size buttonSize;
  final Color color;

  const ButtonText({
    super.key,
    required this.text,
    required this.buttonSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inconsolata(
        textStyle: TextStyle(
          color: color,
          fontSize: getFontSize(buttonSize),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}

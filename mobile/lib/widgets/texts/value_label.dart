import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';

class ValueLabel extends StatelessWidget {
  final String label;
  final String value;
  final int flexLabel;
  final int flexValue;
  final Color? valueColor;
  final double fontSize;
  final IconData? labelIcon;

  const ValueLabel({
    Key? key,
    required this.label,
    required this.value,
    this.flexLabel = 1,
    this.flexValue = 1,
    this.fontSize = 12,
    this.valueColor,
    this.labelIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: flexLabel,
          child: labelIcon != null ? Row(
            children: [
              Icon(
                labelIcon,
                color: AppColor(mainColor),
                size: fontSize + 2,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                textAlign: TextAlign.start,
                style: GoogleFonts.inconsolata(
                  textStyle: TextStyle(
                    fontSize: fontSize-1,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ): Text(
            label,
            textAlign: TextAlign.start,
            style: GoogleFonts.inconsolata(
              textStyle: TextStyle(
                fontSize: fontSize-1,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        Expanded(
          flex: flexValue,
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: GoogleFonts.inconsolata(
              textStyle: TextStyle(
                color: valueColor ?? Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

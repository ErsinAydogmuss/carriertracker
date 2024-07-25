import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';

class InfoBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final IconData? icon;
  final Size size;
  final VoidCallback? onTap;

  const InfoBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.icon,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: AppColor(whiteColor),
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inconsolata(
                        textStyle: TextStyle(
                          color: AppColor(whiteColor),
                          fontSize: getFontSize(size),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (icon == null)
              ...[
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inconsolata(
                    textStyle: TextStyle(
                      color: AppColor(whiteColor),
                      fontSize: getFontSize(size),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../widgets/button/button.dart';

class InfoModal extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Function? onTap;

  const InfoModal({
    super.key, required
    this.text,
    required this.icon,
    this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 75,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.inconsolata(
                textStyle: TextStyle(
                  color: AppColor(blackColor),
                  fontSize: mediumFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: width * 0.5,
              child: Button(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }else {
                    Navigator.pop(context);
                  }
                },
                icon: Icons.check_circle,
                buttonText: 'Tamam',
                size: Size.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
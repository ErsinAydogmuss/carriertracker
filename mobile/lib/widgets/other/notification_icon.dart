import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../utils/notification_provider.dart';

class NotificationIcon extends StatelessWidget {

  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(
          Icons.notifications_rounded,
          color: Colors.white,
        ),
        if (Provider.of<NotificationProvider>(context).unseenNotificationCount > 0)
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                Provider.of<NotificationProvider>(context).unseenNotificationCount > 99 ? '99+' : Provider.of<NotificationProvider>(context).unseenNotificationCount.toString(),
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    color: AppColor(whiteColor),
                    fontWeight: FontWeight.bold,
                    fontSize: xSmallFontSize,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
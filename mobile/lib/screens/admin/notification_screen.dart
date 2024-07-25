import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../models/recieve_message.dart';
import '../../utils/notification_provider.dart';
import '../../widgets/other/loading.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {

  int? userId;
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          ListView.builder(
            itemCount: Provider.of<NotificationProvider>(context, listen: false).notificationList.length,
            itemBuilder: (context, index) {
              return Card(
                color: AppColor(mainLightColor),
                child: ListTile(
                    title: Text(Provider.of<NotificationProvider>(context, listen: false).notificationList[index].orderId,
                      style: GoogleFonts.inconsolata(
                      color: AppColor(whiteColor),
                      fontSize: mediumFontSize,
                      fontWeight: FontWeight.bold,
                    ),),
                    subtitle: Text(Provider.of<NotificationProvider>(context, listen: false).notificationList[index].receiverId,
                      style: GoogleFonts.inconsolata(
                      color: AppColor(whiteColor),
                      fontSize: smallFontSize,
                    ),),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColor(whiteColor),
                    )
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

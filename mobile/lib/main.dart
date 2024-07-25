import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:yetis_mobile/services/socket.dart';
import 'package:yetis_mobile/utils/notification_provider.dart';
import 'Screens/Welcome/welcome_screen.dart';
import 'constants/app_color.dart';
import 'constants/constants.dart';

void main() async {
  await GetStorage.init();

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => SocketService()),
        ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor(mainColor),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yetis_mobile/Screens/auth/login_screen.dart';
import 'package:yetis_mobile/screens/admin/notification_screen.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../constants/app_color.dart';
import '../constants/constants.dart';
import '../models/recieve_message.dart';
import '../screens/admin/order_list_screen.dart';
import '../services/socket.dart';
import '../utils/notification_provider.dart';
import 'other/notification_icon.dart';


class NavigationMenuBarForAdmin extends StatefulWidget {
  const NavigationMenuBarForAdmin({super.key});

  @override
  NavigationMenuBarForAdminState createState() => NavigationMenuBarForAdminState();
}

class NavigationMenuBarForAdminState extends State<NavigationMenuBarForAdmin> {
  int _selectedIndex = 0;
  String? appBarTitle;

  bool isGeneral = true;
  late List<Widget> _pages;
  late String currentUserId;
  late SocketService socketService;
  String? name;
  int? userId;

  void addReceivedMessage(ReceivedMessage message) {
    print(message);
    setState(() {
      Provider.of<NotificationProvider>(context, listen: false)
          .addNotification(message);
    });
  }

  @override
  void initState() {
    super.initState();
    GetStorage box = GetStorage();
    name = box.read('user')['name'];
    userId = box.read('user')['id'];
    appBarTitle = "Merhaba ${name!}!";

    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.initiateSocketConnection();

    socketService.addUser(userId.toString());
    socketService.listenToMessages(addReceivedMessage);

    _pages = [
      const OrderListScreen(),
      const NotificationScreen(),
      const Center(
        child: Text("Çıkış Yapılıyor"),
      ),
    ];
  }

  onItemTapped(int index) {
    setState(() {
      isGeneral = false;
      _selectedIndex = index;

      switch (index) {
        case 0:
          appBarTitle = "Merhaba ${name!}!";
          break;
        case 1:
          appBarTitle = "Bildirimlerim";
          break;
        case 2:
          GetStorage box = GetStorage();
          box.remove('user');
          box.remove('token');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            ),
                (route) => false,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: Head(
          text: appBarTitle ?? "",
          size: Size.large,
          color: AppColor(mainColor),
        ),
        backgroundColor: AppColor(whiteColor),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 25,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: GoogleFonts.inconsolata(
          textStyle: TextStyle(
            color: AppColor(whiteColor),
            fontWeight: FontWeight.bold,
          ),
        ),
        unselectedLabelStyle: GoogleFonts.inconsolata(
          textStyle: TextStyle(
            color: AppColor(whiteColor),
          ),
        ),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor(mainColor),
        selectedItemColor: AppColor(whiteColor),
        unselectedItemColor: AppColor(whiteColor),
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.backpack_rounded,
              color: AppColor(whiteColor),
            ),
            label: 'Siparişler',
          ),
          const BottomNavigationBarItem(
            icon: NotificationIcon(),
            label: 'Bildirimler',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              color: AppColor(whiteColor),
            ),
            label: 'Çıkış Yap',
          ),
        ],
      ),
    );
  }
}

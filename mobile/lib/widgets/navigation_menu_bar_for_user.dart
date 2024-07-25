import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yetis_mobile/screens/user/create_order_screen.dart';
import 'package:yetis_mobile/screens/user/my_orders_screen.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../Screens/auth/login_screen.dart';
import '../constants/app_color.dart';
import '../constants/constants.dart';


class NavigationMenuBarForUser extends StatefulWidget {
  const NavigationMenuBarForUser({super.key});

  @override
  NavigationMenuBarForUserState createState() => NavigationMenuBarForUserState();
}

class NavigationMenuBarForUserState extends State<NavigationMenuBarForUser> {
  int _selectedIndex = 0;
  String? appBarTitle;

  bool isGeneral = true;
  late List<Widget> _pages;
  late String currentUserId;
  String? name;


  @override
  void initState() {
    super.initState();
    GetStorage box = GetStorage();
    name = box.read('user')['name'];
    appBarTitle = "Merhaba ${name!}!";

    _pages = [
      const CreateOrderScreen(),
      const MyOrdersScreen(),
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
          appBarTitle = "Siparişlerim";
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
            label: 'Kurye Çağır',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_rounded,
              color: AppColor(whiteColor),
            ),
            label: 'Siparişlerim',
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

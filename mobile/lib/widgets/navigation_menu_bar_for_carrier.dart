import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yetis_mobile/screens/carrier/delivery_screen.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../Screens/auth/login_screen.dart';
import '../constants/app_color.dart';
import '../constants/constants.dart';
import '../services/carrier_service.dart';
import '../services/socket.dart';
import 'modals/info_modal.dart';


class NavigationMenuBarForCarrier extends StatefulWidget {
  const NavigationMenuBarForCarrier({super.key});

  @override
  NavigationMenuBarForCarrierState createState() => NavigationMenuBarForCarrierState();
}

class NavigationMenuBarForCarrierState extends State<NavigationMenuBarForCarrier> {
  int _selectedIndex = 0;
  String? appBarTitle;

  bool isGeneral = true;
  late List<Widget> _pages;
  late String currentUserId;
  late SocketService socketService;
  String? name;
  bool? isReady;
  int? carrierId;


  @override
  void initState() {
    super.initState();
    GetStorage box = GetStorage();
    name = box.read('user')['name'];
    isReady = box.read('user')['isReady'];
    int userId = box.read('user')['id'];
    carrierId = box.read('user')['carrierId'];
    appBarTitle = "Merhaba ${name!}!";
    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.initiateSocketConnection();

    socketService.addUser(userId.toString());
    _pages = [
      const DeliveryScreen(),
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
          appBarTitle = "Ana Sayfa";
          break;
        case 1:
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

  changeCarrierStatus() async {
    var response = await CarrierService().changeCarrierStatus(
        carrierId: carrierId!,
        isReady: !isReady!
    );

    if(response.success) {
      setState(() {
        isReady = !isReady!;
      });
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoModal(
            iconColor: AppColor(mainColor),
            text: response.message!,
            icon: Icons.error,
          );
        },
      );
    }
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
        actions: [
          isReady == true
              ? Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.location_off,
                  color: AppColor(redColor),
                ),
                onPressed: () {
                  changeCarrierStatus();
                },
              ),
              Text(
                "Çevrimdışı ol",
                style: GoogleFonts.inconsolata(
                  textStyle: TextStyle(
                    color: AppColor(redColor),
                    fontWeight: FontWeight.bold,
                    fontSize: smallFontSize,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          )
              :
          Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: AppColor(mainColor),
                  ),
                  onPressed: () {
                    changeCarrierStatus();
                  },
                ),
                Text(
                  "Çalışmaya Hazırım",
                  style: GoogleFonts.inconsolata(
                    textStyle: TextStyle(
                      color: AppColor(mainColor),
                      fontWeight: FontWeight.bold,
                      fontSize: smallFontSize,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ]
          ),
        ],
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
              Icons.home_rounded,
              color: AppColor(whiteColor),
            ),
            label: 'Ana Sayfa',
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

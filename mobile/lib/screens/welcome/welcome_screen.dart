import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../widgets/button/button.dart';
import '../../widgets/texts/head.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Head(text: 'Kurye Takip Sistemine Hoşgeldin !', size: Size.xLarge, color: AppColor(mainColor)),
              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: Button(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      },
                      buttonText: 'Giriş Yap',
                      size: Size.large,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: width * 0.7,
                    child: Button(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ),
                        );
                      },
                      buttonText: 'Kayıt Ol',
                      size: Size.large,
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yetis_mobile/screens/auth/signup_screen.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../services/auth_service.dart';
import '../../widgets/button/button.dart';
import '../../widgets/form/input.dart';
import '../../widgets/modals/info_modal.dart';
import '../../widgets/navigation_menu_bar_for_admin.dart';
import '../../widgets/navigation_menu_bar_for_carrier.dart';
import '../../widgets/navigation_menu_bar_for_user.dart';
import '../../widgets/other/loading.dart';
import '../../widgets/texts/head.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorMessage = "";
  bool isLoading = false;
  String dropdownValue = 'ADMIN';

  Map<String, String> userTypes = {
    'Yönetici': 'ADMIN',
    'Kurye': 'CARRIER',
    'Kullanıcı': 'USER'
  };

  login() async {
    setState(() {
      isLoading = true;
    });

    AuthService().login(
        email: _emailController.text,
        password: _passwordController.text,
        role: dropdownValue
    ).then((response) {

      if (response.success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (dropdownValue == 'ADMIN') {
                return const NavigationMenuBarForAdmin();
              } else if (dropdownValue == 'CARRIER') {
                return const NavigationMenuBarForCarrier();
              } else {
                return const NavigationMenuBarForUser();
              }
            },
          ),
              (route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
        });

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return InfoModal(
              iconColor: AppColor(mainColor),
              text: response.message!,
              icon: Icons.check_circle,
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Head(
                      text: 'Giriş Yap',
                      size: Size.xLarge,
                      color: AppColor(mainColor),
                      icon: Icons.delivery_dining,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColor(mainColor),
                                width: 1,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor(mainColor),
                                  size: 25,
                                ),
                                hint: Head(
                                  text: "Seçiniz...",
                                  size: Size.small,
                                  color: AppColor(mainColor),
                                ),
                                underline: Container(),
                                iconDisabledColor: AppColor(hintColor),
                                iconEnabledColor: AppColor(blackColor).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                isExpanded: true,
                                items: userTypes.entries.map<DropdownMenuItem<String>>((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Head(
                                      text: entry.key,
                                      size: Size.small,
                                      color: AppColor(blackColor),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          FormInput(
                            labelText: "E-Posta",
                            hintText: "E-Posta adresinizi giriniz...",
                            prefixIcon: Icons.email,
                            controller: _emailController,
                            hintFontSize: xSmallFontSize,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          FormInput(
                            labelText: "Şifreniz",
                            hintText: "Lütfen şifrenizi giriniz",
                            prefixIcon: Icons.lock,
                            suffixIcon: Icons.visibility,
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            hintFontSize: xSmallFontSize,
                            isObscureText: true,
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                            width: width * 0.5,
                            child: Button(
                              onTap: () async {
                                await login();
                              },
                              size: Size.large,
                              buttonText: 'Giriş Yap',
                            ),
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: "Henüz bir hesabınız yok mu? ",
                              style: GoogleFonts.inconsolata(
                                textStyle: TextStyle(
                                  color: AppColor(blackColor),
                                  fontSize: mediumFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                TextSpan(
                                  text: "Kayıt Ol",
                                  style: GoogleFonts.inconsolata(
                                    textStyle: TextStyle(
                                      color: AppColor(mainColor),
                                      fontSize: mediumFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignUpScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          isLoading ? const Loading() : const SizedBox(),
        ],
      ),
    );
  }
}

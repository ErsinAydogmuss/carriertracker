import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yetis_mobile/widgets/button/button.dart';
import 'package:yetis_mobile/widgets/texts/head.dart';
import '../../Screens/auth/login_screen.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import '../../widgets/form/input.dart';
import '../../widgets/other/loading.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Head(text: "Kurye Takip Sistemi", size: Size.large, color: AppColor(mainColor), icon: Icons.delivery_dining),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width * 0.95,
                    child: FormInput(
                      labelText: "Ad",
                      hintText: "Adınızı giriniz...",
                      controller: _firstnameController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.text_fields,
                      labelFontSize: smallFontSize,
                      hintFontSize: xSmallFontSize,
                      fontSize: smallFontSize,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: width * 0.95,
                    child: FormInput(
                      labelText: "E-Posta",
                      hintText: "E-Posta adresinizi giriniz...",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                      labelFontSize: smallFontSize,
                      hintFontSize: xSmallFontSize,
                      fontSize: smallFontSize,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: width * 0.95,
                    child: FormInput(
                      labelText: "Şifre",
                      hintText: "Lütfen şifrenizi girin",
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.lock,
                      labelFontSize: smallFontSize,
                      hintFontSize: smallFontSize,
                      isObscureText: true,
                      suffixIcon: Icons.visibility,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: width * 0.95,
                    child: FormInput(
                      labelText: "Tekrar Şifre",
                      hintText: "Lütfen şifrenizi tekrar giriniz",
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.lock_reset_rounded,
                      labelFontSize: smallFontSize,
                      hintFontSize: smallFontSize,
                      isObscureText: true,
                      suffixIcon: Icons.visibility,
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: width * 0.5,
                    child: Button(onTap: () {}, buttonText: "Kayıt Ol"),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Zaten bir hesabınız var mı? ",
                      style:  GoogleFonts.inconsolata(
                        textStyle: TextStyle(
                          color: AppColor(blackColor),
                          fontSize: smallFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: "Giriş Yap",
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
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
        isLoading ? const Loading() : const SizedBox(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';

class Loading extends StatelessWidget {
  final bool? isModal;

  const Loading({super.key, this.isModal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(
        borderRadius: isModal == true ? BorderRadius.circular(10) : BorderRadius.circular(0),
        color: Colors.black.withOpacity(0.1),
      ),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColor(mainColor),
          color: AppColor(mainColor),
          strokeWidth: 6,
          semanticsLabel: 'Yükleniyor',
          semanticsValue: 'Yükleniyor',
          valueColor: AlwaysStoppedAnimation<Color>(AppColor(whiteColor)),
        ),
      ),
    );
  }
}
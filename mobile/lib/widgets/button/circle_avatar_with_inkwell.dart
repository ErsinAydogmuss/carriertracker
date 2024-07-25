import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';

class CircleAvatarWithInkWell extends StatelessWidget {
  final VoidCallback? onTap;
  final String? imagePath;
  final double size;

  const CircleAvatarWithInkWell({
    super.key,
    this.onTap,
    this.imagePath,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor(mainColor),
            width: 2.0,
          ),
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imagePath == null ? const AssetImage('assets/images/profile.png') :
            imagePath!.startsWith('http')
                ? NetworkImage(imagePath!)
                : AssetImage(imagePath!) as ImageProvider,
          ),
        ),
      ),
    );
  }
}

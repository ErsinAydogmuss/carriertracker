import 'package:flutter/material.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';
import 'button_text.dart';

class Button extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Size size;
  final ButtonType buttonType;
  final IconData? icon;
  final IconLocation? iconLocation;
  final bool isEnabled;

  const Button({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.size = Size.medium,
    this.buttonType = ButtonType.primary,
    this.icon,
    this.iconLocation,
    this.isEnabled = true,
  });

  Color getGradientStartColor() {
    switch (buttonType) {
      case ButtonType.primary:
        return AppColor(mainColor);
      case ButtonType.secondary:
        return Colors.green.shade800;
      case ButtonType.tertiary:
        return Colors.red.shade500;
      case ButtonType.info:
        return Colors.yellow.shade500;
    }
  }

  Color getGradientEndColor() {
    switch (buttonType) {
      case ButtonType.primary:
        return AppColor(mainLightColor);
      case ButtonType.secondary:
        return Colors.green.shade400;
      case ButtonType.tertiary:
        return Colors.red.shade400;
      case ButtonType.info:
        return Colors.yellow.shade400;
    }
  }

  double getButtonWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.35;
  }

  double getButtonHeight() {
    switch (size) {
      case Size.xSmall:
        return 30;
      case Size.small:
        return 40;
      case Size.medium:
        return 40;
      case Size.large:
        return 50;
      case Size.xLarge:
        return 55;
    }
  }

  double getIconSize() {
    switch (size) {
      case Size.xSmall:
        return 18;
      case Size.small:
        return 20;
      case Size.medium:
        return 24;
      case Size.large:
        return 28;
      case Size.xLarge:
        return 32;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [getGradientStartColor(), getGradientEndColor()],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColor(boxShadowColor),
                offset: const Offset(0, 3),
                blurRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && iconLocation == IconLocation.left)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: getIconSize(),
                    ),
                  ),
                ButtonText(
                  text: buttonText,
                  buttonSize: size,
                  color: AppColor(whiteColor),
                ),
                if (icon != null && iconLocation == IconLocation.right)
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: getIconSize(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum Size { xSmall, small, medium, large, xLarge }

enum ButtonType { primary, secondary, tertiary, info }

enum IconLocation { left, right }

const double defaultPadding = 8.0;

//Api Urls

const String baseUrl = "http://localhost:3000";

const String registerUrl = "$baseUrl/auth/register";
const String loginUrl = "$baseUrl/auth/login";
const String createOrderUrl = "$baseUrl/orders";
const String getPendingOrderListUrl = "$baseUrl/orders/pending";
const String getPendingCarrierListUrl = "$baseUrl/carriers";
const String assignCarrierUrl = "$baseUrl/orders/assign";
const String getMyDeliveryUrl = "$baseUrl/carriers/{carrierId}/orders";
const String updateLocationUrl = "$baseUrl/carriers/{carrierId}/location";
const String finishDeliveryUrl = "$baseUrl/carriers/{carrierId}";
const String getMyOrdersUrl = "$baseUrl/orders/user?userId={userId}";
const String changeCarrierStatusUrl = "$baseUrl/carriers/{carrierId}/status";

//Colors
const mainColor = '008331';
const mainLightColor = '66b483';
const String labelColor = "9E9E9E";
const String hintColor = "3e3e3e";
const String errorColor = "FF0000";
const String successColor = "00FF00";
const String whiteColor = "FFFFFF";
const String blackColor = "000000";
const String redColor = "FF0000";
const String greenColor = "00FF00";
const String grayColor = "808080";
const String orangeColor = "FFA500";
const String purpleColor = "800080";
const String blueColor = "0000FF";
const String yellowColor = "FFBF00";
const String boxShadowColor = "2D2F3A";

// Font Sizes
const double xSmallFontSize = 12.0;
const double smallFontSize = 14.0;
const double mediumFontSize = 16.0;
const double largeFontSize = 20.0;
const double xLargeFontSize = 30.0;

double getFontSize(Size size) {
  switch (size) {
    case Size.xSmall:
      return xSmallFontSize;
    case Size.small:
      return smallFontSize;
    case Size.medium:
      return mediumFontSize;
    case Size.large:
      return largeFontSize;
    case Size.xLarge:
      return xLargeFontSize;
    default:
      return mediumFontSize;
  }
}

BoxShadow getShadow() {
  return BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  );
}

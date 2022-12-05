import 'package:flutter/material.dart';
import 'package:lovelace/core/app_export.dart';

class AppStyle {
  static TextStyle txtRobotoRegular16 = TextStyle(
    color: ColorConstant.bluegray400,
    fontSize: getFontSize(
      16,
    ),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  static TextStyle txtInterSemiBold15 = TextStyle(
    color: ColorConstant.whiteA700,
    fontSize: getFontSize(
      15,
    ),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  static TextStyle txtInterSemiBold35 = TextStyle(
    color: ColorConstant.gray100,
    fontSize: getFontSize(
      35,
    ),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  static TextStyle txtRobotoRegular20 = TextStyle(
    color: ColorConstant.black900,
    fontSize: getFontSize(
      20,
    ),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
}

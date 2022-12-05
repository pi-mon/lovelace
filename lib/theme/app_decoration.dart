import 'package:flutter/material.dart';
import 'package:lovelace/core/app_export.dart';

class AppDecoration {
  static BoxDecoration get fillGray900 => BoxDecoration(
        color: ColorConstant.gray900,
      );
  static BoxDecoration get fillPurpleA700 => BoxDecoration(
        color: ColorConstant.purpleA700,
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: ColorConstant.gray100,
      );
  static BoxDecoration get outlinePurpleA200 => BoxDecoration(
        color: ColorConstant.purpleA700,
        border: Border.all(
          color: ColorConstant.purpleA200,
          width: getHorizontalSize(
            1.00,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
}

class BorderRadiusStyle {
  static BorderRadius circleBorder25 = BorderRadius.circular(
    getHorizontalSize(
      25.00,
    ),
  );

  static BorderRadius roundedBorder15 = BorderRadius.circular(
    getHorizontalSize(
      15.00,
    ),
  );
}

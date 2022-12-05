import 'controller/landing_controller.dart';
import 'package:flutter/material.dart';
import 'package:lovelace/core/app_export.dart';
import 'package:lovelace/widgets/app_bar/custom_app_bar.dart';

class LandingScreen extends GetWidget<LandingController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray100,
        appBar: CustomAppBar(
          height: getVerticalSize(
            75.00,
          ),
          centerTitle: true,
          title: Container(
            decoration: AppDecoration.outlinePurpleA200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: getPadding(
                    left: 14,
                    top: 13,
                    bottom: 12,
                  ),
                  child: CommonImageView(
                    imagePath: ImageConstant.imgLogo,
                    height: getSize(
                      50.00,
                    ),
                    width: getSize(
                      50.00,
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 265,
                    top: 13,
                    right: 11,
                    bottom: 12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(
                        25.00,
                      ),
                    ),
                    child: CommonImageView(
                      imagePath: ImageConstant.imgEllipse3,
                      height: getSize(
                        50.00,
                      ),
                      width: getSize(
                        50.00,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          styleType: Style.bgOutlinePurpleA200,
        ),
        body: Container(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: getVerticalSize(
                    525.00,
                  ),
                  width: getHorizontalSize(
                    350.00,
                  ),
                  margin: getMargin(
                    left: 20,
                    top: 27,
                    right: 20,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(
                              15.00,
                            ),
                          ),
                          child: CommonImageView(
                            imagePath: ImageConstant.imgUserimg,
                            height: getVerticalSize(
                              525.00,
                            ),
                            width: getHorizontalSize(
                              350.00,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: getPadding(
                            left: 18,
                            top: 26,
                            right: 18,
                            bottom: 26,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(
                                  left: 1,
                                  right: 10,
                                ),
                                child: Text(
                                  "lbl_shin".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterSemiBold35,
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  top: 1,
                                ),
                                child: Text(
                                  "lbl_18_sembawang".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterSemiBold15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 20,
                    top: 19,
                    right: 20,
                    bottom: 23,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: getSize(
                          175.00,
                        ),
                        width: getSize(
                          175.00,
                        ),
                        decoration: AppDecoration.fillPurpleA700,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: getPadding(
                                  all: 40,
                                ),
                                child: CommonImageView(
                                  svgPath: ImageConstant.imgForward,
                                  height: getVerticalSize(
                                    75.00,
                                  ),
                                  width: getHorizontalSize(
                                    85.00,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getSize(
                          175.00,
                        ),
                        width: getSize(
                          175.00,
                        ),
                        decoration: AppDecoration.fillGray900,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: getPadding(
                                  left: 40,
                                  top: 40,
                                  right: 40,
                                  bottom: 5,
                                ),
                                child: CommonImageView(
                                  svgPath: ImageConstant.imgUser,
                                  height: getVerticalSize(
                                    75.00,
                                  ),
                                  width: getHorizontalSize(
                                    84.00,
                                  ),
                                ),
                              ),
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
    );
  }
}

import 'package:lovelace/core/app_export.dart';
import 'package:lovelace/presentation/landing_screen/models/landing_model.dart';

class LandingController extends GetxController {
  Rx<LandingModel> landingModelObj = LandingModel().obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

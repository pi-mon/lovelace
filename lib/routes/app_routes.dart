import 'package:lovelace/presentation/landing_screen/landing_screen.dart';
import 'package:lovelace/presentation/landing_screen/binding/landing_binding.dart';
import 'package:lovelace/presentation/app_navigation_screen/app_navigation_screen.dart';
import 'package:lovelace/presentation/app_navigation_screen/binding/app_navigation_binding.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String landingScreen = '/landing_screen';

  static String appNavigationScreen = '/app_navigation_screen';

  static String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: landingScreen,
      page: () => LandingScreen(),
      bindings: [
        LandingBinding(),
      ],
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [
        AppNavigationBinding(),
      ],
    ),
    GetPage(
      name: initialRoute,
      page: () => LandingScreen(),
      bindings: [
        LandingBinding(),
      ],
    )
  ];
}

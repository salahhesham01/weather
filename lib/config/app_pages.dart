import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:weather/presentation/home/view/home_screen.dart';
import 'package:weather/presentation/week/view/week_screen.dart';

import '../presentation/splash/view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(name: AppRoutes.initial, page: () => SplashScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.week, page: () => WeekScreen()),
  ];
}

import 'dart:async';

import 'package:get/get.dart';
import 'package:weather/config/app_pages.dart';
import 'package:weather/config/app_routes.dart';

class SplashController extends GetxController{
  void splashTimer(){
      Timer(
         Duration(seconds: 2),(){
           Get.offNamed(AppRoutes.home);
      }
      );
    }
}
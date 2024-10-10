import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController controller=Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    controller.splashTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

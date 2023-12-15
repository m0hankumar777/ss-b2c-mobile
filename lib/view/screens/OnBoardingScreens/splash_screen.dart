import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/main.dart';
import 'package:B2C/utility/images.dart' as img;
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:B2C/view/screens/OnBoardingScreens/intro_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/profile_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstTime = false;
  final customerController = Get.put(CustomerController());
  final profileController = Get.put(ProfileController());
  final localizationController = Get.put(LocalizationController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    await PushNotification().initNotifications(context);
    introScreen();
    customerController.getUserInformation();
    await profileController.introScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSplashScreen(
        splash: Image.asset(img.splash),
        nextScreen:
            isFirstTime ? const IntroScreen() : HomeScreen(selectedIndex: 2),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colr.primary,
        duration: 200,
      ),
    );
  }

  introScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAppPreviouslyLaunched =
        prefs.getBool('isAppPreviouslyLaunched') ?? false;
    if (!isAppPreviouslyLaunched) {
      prefs.setBool('isAppPreviouslyLaunched', true);
      setState(() {
        isFirstTime = true;
      });
    }

    // if (loginAuth.getLoginStatus() == true) {
    //   setState(() {
    //     isLogin = true;
    //   });
    // }
  }
}

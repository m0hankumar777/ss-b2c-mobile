import 'package:B2C/view/screens/Authentication/login_screen.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:B2C/utility/images.dart' as img;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utility/themes_b2c.dart';
import '../../../utility/widget_helper/common_text_widget.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List introImages = [img.slide1, img.slide2, img.slide3];
  int currentIndex = 0;
  bool? isLoginCLicked = false;
  bool? isSignUpCLicked = false;
  // ignore: unused_field
  String _authStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      // ignore: use_build_context_synchronously
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    // ignore: unused_local_variable
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black),
      child: Scaffold(
        body: Stack(children: [
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: introImages.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: Get.height,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.6), BlendMode.luminosity),
                  child: Image.asset(introImages[index], fit: BoxFit.fill),
                ),
              );
            },
          ),
          Positioned(
              top: Get.height * .06,
              left: Get.width * .78,
              child: InkWell(
                onTap: () {
                  Get.offAll(HomeScreen(
                    selectedIndex: 2,
                  ));
                  // Get.to(() => HomeScreen(
                  //       selectedIndex: 2,
                  //     ));
                },
                child: SizedBox(
                  height: Get.height * .04,
                  child: Center(
                    child: Row(
                      children: [
                        CommenTextWidget(
                          s: "skip".tr,
                          size: Get.height * 0.022,
                          fw: FontWeight.bold,
                          clr: Colr.primaryLight,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: Get.height / 50,
                            color: Colr.primaryLight,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
          Positioned(
              top: Get.height * .5,
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommenTextWidget(
                        s: "Welcome to Glamz".tr,
                        size: Get.height * 0.024,
                        fw: FontWeight.w700,
                        clr: Colr.primaryLight,
                      ),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      CommenTextWidget(
                        s: "The app that allows you to\nmake appointments easily and\nquickly for all recommended beauty\nprofessionals in Israel! \nAll you have to do is choose!"
                            .tr,
                        size: Get.height * 0.024,
                        fw: FontWeight.w700,
                        clr: Colr.primaryLight,
                      ),
                      SizedBox(
                        height: Get.height * .05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            introImages.length, (index) => line(index)),
                      ),
                      SizedBox(
                        height: Get.height * .05,
                      ),
                      login(),
                      SizedBox(
                        height: Get.height * .02,
                      ),
                      register(),
                      // SizedBox(
                      //   height: Get.height * .02,
                      // ),
                      // if (Platform.isAndroid)
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         decoration: BoxDecoration(
                      //             color: Colors.black,
                      //             borderRadius: BorderRadius.circular(5)),
                      //         height: Get.height * .006,
                      //         width: Get.width * .4,
                      //       )
                      //     ],
                      //   )
                    ],
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  line(int index) {
    return Container(
        height: Get.height * .004,
        width: 20,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index ? Colr.primaryLight : Colors.white54,
        ));
  }

  login() {
    return InkWell(
      onTap: () {
        setState(() {
          isLoginCLicked = !isLoginCLicked!;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    isLoginCLicked: true,
                  )),
        );
      },
      child: Container(
        height: Get.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isLoginCLicked!
                ? Colors.white
                : isSignUpCLicked!
                    ? Colors.transparent
                    : Colr.primaryLight,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.white,
            )),
        child: Center(
            child: CommenTextWidget(
          s: "Login".tr,
          size: 15,
          clr: isLoginCLicked!
              ? Colr.primary
              : isSignUpCLicked!
                  ? Colr.primaryLight
                  : Colr.primary,
          fw: FontWeight.w700,
        )),
      ),
    );
  }

  register() {
    return InkWell(
      onTap: () {
        setState(() {
          isSignUpCLicked = !isSignUpCLicked!;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(
                    isLoginCLicked: false,
                  )),
        );
      },
      child: Container(
        height: Get.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isSignUpCLicked!
                ? Colors.white
                : isLoginCLicked!
                    ? Colors.transparent
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Colr.primaryLight)),
        child: Center(
            child: CommenTextWidget(
          s: "Register".tr,
          size: 15,
          clr: isSignUpCLicked! ? Colr.primary : Colors.white,
          fw: FontWeight.w700,
        )),
      ),
    );
  }
}

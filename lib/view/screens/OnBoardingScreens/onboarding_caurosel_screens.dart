
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/utility/widget_helper/common_elevated_button.dart';
import 'package:B2C/view/screens/Authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:B2C/utility/images.dart' as img;

class CarouselSliderScreen extends StatefulWidget {
  const CarouselSliderScreen({super.key});

  @override
  State<CarouselSliderScreen> createState() => _CarouselSliderScreenState();
}

class _CarouselSliderScreenState extends State<CarouselSliderScreen> {
  final localizationController = Get.put(LocalizationController());
  Material? materialButton;
  int? index;
  bool? isLoginCLicked = false;
  bool? isSignUpCLicked = false;
  int pageindex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    // Get.updateLocale(Locale('he', 'IL'));
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Scaffold(
          body: PageView(
        controller: pageController,
        onPageChanged: (int index) {
          pageindex = index;
        },
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                Image.asset(
                  img.slide1,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                // ignore: prefer_const_constructors
                blur(),
                Login(),
                Register(),
                Positioned(
                  bottom: 130,
                  left: 50,
                  right: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < 3; i++)
                                if (i == 0) ...[LinearBar(true)] else
                                  LinearBar(false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GlamzTest(),

                //
              ],
            ),
          ),
          Center(
            child: Stack(
              children: [
                Image.asset(
                  img.slide2,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  // fit: BoxFit.fitHeight,
                ),
                // ignore: prefer_const_constructors
                blur(),
                Login(),
                Register(),
                Positioned(
                  bottom: 130,
                  left: 50,
                  right: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < 3; i++)
                                if (i == 1) ...[LinearBar(true)] else
                                  LinearBar(false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GlamzTest(),
              ],
            ),
          ),
          Center(
            child: Stack(
              children: [
                Image.asset(
                  img.slide3,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                // ignore: prefer_const_constructors
                blur(),
                Login(),
                Register(),
                Positioned(
                  bottom: 130,
                  left: 50,
                  right: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < 3; i++)
                                if (i == 2) ...[LinearBar(true)] else
                                  LinearBar(false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GlamzTest(),
              ],
            ),
          )
        ],
      )),
    );
  }

  // ignore: non_constant_identifier_names
  Widget GlamzTest() {
    return Positioned(
        bottom: 185,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 75, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommenTextWidget(
                s: "Welcome to Glamz".tr,
                size: 20,
                fw: FontWeight.w400,
                clr: Colr.primaryLight,
              ),
              Container(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 3, right: 50),
                child: CommenTextWidget(
                  s: "The app that allows you to\nmake appointments easily and\nquickly for all recommended beauty\nprofessionals in Israel! \nAll you have to do is choose!"
                      .tr,
                  size: 18,
                  fw: FontWeight.w400,
                  clr: Colr.primaryLight,
                ),
              ),
            ],
          ),
        ));
  }

  Widget blur() {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(0, 0, 0, 0.5));
  }

  // ignore: non_constant_identifier_names
  Widget Login() {
    return Positioned(
        bottom: 100,
        right: 15,
        left: 15,
        child: GestureDetector(
          onTap: () {
            // loading.showLoaderDialog(context);
          },
          child: AppButtons(
            textColor: isLoginCLicked!
                ? Colr.primary
                : isSignUpCLicked!
                    ? Colr.secondaryGrey
                    : Colr.primary,
            backgroundColor: isLoginCLicked!
                ? Colors.white
                : isSignUpCLicked!
                    ? Colors.transparent
                    : Colr.primaryLight,
            borderColor: Colors.white,
            text: "Login".tr,
            fontWeight: FontWeight.w500,
            fontSize: 15,
            size: 50,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            onPressed: () {
              setState(() {
                isLoginCLicked = !isLoginCLicked!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(isLoginCLicked: true)),
                );
              });
            },
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Widget Register() {
    return Positioned(
        bottom: 30,
        right: 15,
        left: 15,
        child: GestureDetector(
          onTap: () {
            // loading.showLoaderDialog(context);
          },
          child: AppButtons(
            textColor: isSignUpCLicked! ? Colr.primary : Colors.white,
            backgroundColor: isSignUpCLicked!
                ? Colors.white
                : isLoginCLicked!
                    ? Colors.transparent
                    : Colors.transparent,
            borderColor: Colors.white,
            text: "Register".tr,
            fontWeight: FontWeight.w500,
            fontSize: 15,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            onPressed: () {
              setState(() {
                isSignUpCLicked = !isSignUpCLicked!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                            isLoginCLicked: false,
                          )),
                );
              });
            },
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  Widget LinearBar(bool isActive) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: isActive ? 3 : 3,
        width: isActive ? 30 : 30,
        decoration: BoxDecoration(
            color: isActive
                ? Colr.primaryLight
                : Colr.primaryLight.withOpacity(0.3)));
  }
}

import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/ui_helper.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return commonToast('No Internet'.tr);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/noInternet.png"),
              CommenTextWidget(
                clr: Colr.primary,
                size: 18,
                s: "No Internet".tr,
                fw: FontWeight.bold,
              )
            ],
          ),
        ),
      ),
    );
  }
}

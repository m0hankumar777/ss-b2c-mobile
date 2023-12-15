import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoItemFound extends StatefulWidget {
  const NoItemFound({super.key});

  @override
  State<NoItemFound> createState() => _NoItemFoundState();
}

class _NoItemFoundState extends State<NoItemFound> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.width / 10),
      child: Column(
        children: [
          Container(
            height: Get.height * 0.108,
            width: Get.width * 0.445,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(),
              image: DecorationImage(
                  image: AssetImage('assets/images/Search1.png'),
                  opacity: 1.0,
                  fit: BoxFit.fill,
                  scale: 1.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Get.width * 0.037),
            child: Center(
              child: CommenTextWidget(
                s: 'No Results Found'.tr,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
                clr: Colr.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

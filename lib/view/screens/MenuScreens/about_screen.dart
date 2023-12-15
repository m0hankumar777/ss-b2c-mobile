import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utility/themes_b2c.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // ignore: non_constant_identifier_names
  List<dynamic> Images = [
    "assets/images/team1.png",
    "assets/images/team2.png",
    "assets/images/team3.png",
    "assets/images/team4.png",
    "assets/images/team5.png",
    "assets/images/team6.png",
    "assets/images/team7.png",
    "assets/images/team8.png",
    "assets/images/team9.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colr.primary,
        centerTitle: true,
        title: CommenTextWidget(
          s: "About".tr,
          size: 22,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              CommenTextWidget(
                  s: "nice".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              CommenTextWidget(
                s: "para1".tr,
                size: 20,
              ),
              CommenTextWidget(
                  s: "choose".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              CommenTextWidget(
                s: "para2".tr,
                size: 20,
              ),
              CommenTextWidget(
                  s: "quality".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              CommenTextWidget(
                s: "para3".tr,
                size: 20,
              ),
              const SizedBox(height: 20.0),
              CommenTextWidget(
                  s: "consumers".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              CommenTextWidget(
                  s: "professionals".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              CommenTextWidget(
                  s: "beauty".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              CommenTextWidget(
                  s: "team".tr,
                  clr: Colr.primary,
                  size: 25,
                  fw: FontWeight.bold),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 350,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1.1),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(Images[index]);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

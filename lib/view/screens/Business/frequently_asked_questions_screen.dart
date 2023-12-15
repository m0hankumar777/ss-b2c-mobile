import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/business_controller.dart';
import '../../../controller/homescreen_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../utility/themes_b2c.dart';
import 'package:B2C/utility/images.dart' as images;

import '../../../utility/widget_helper/common_text_widget.dart';

// ignore: must_be_immutable
class FAQScreen extends StatefulWidget {
  int businessId;
  FAQScreen(this.businessId, {super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final businessController = Get.put(BusinessController());
  final localizationController = Get.put(LocalizationController());

  int? _selectedIndex = 0;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    await homeScreenController.getAllCategories();
    await businessController.getFaq(widget.businessId, 2);
    setState(() {
      isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoad
          ? SingleChildScrollView(
              child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ), //top level space
                CategoriesSlider(context),
                const Divider(
                  height: 2,
                ),
                questionsAndAnswers()
              ],
            ))
          : Center(
              child: CircularProgressIndicator(color: Colr.primary),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox CategoriesSlider(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: homeScreenController.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              setState(() {
                _selectedIndex = index;
              });
              await businessController.getFaq(
                  widget.businessId, homeScreenController.categories[index].id);
            },
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: CircleAvatar(
                    radius: _selectedIndex == index ? 35 : 40,
                    backgroundColor: _selectedIndex == index
                        ? Colr.primary
                        : Colors.transparent,
                    backgroundImage: AssetImage(
                      _selectedIndex == index
                          ? images.categoryImages[index]
                          : images.categoryLightImages[index],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: CommenTextWidget(
                      s: localizationController.isHebrew.value
                          ? homeScreenController.categories[index].categoryNameH
                          : homeScreenController.categories[index].name
                              .toCapitalCase(),
                      align: TextAlign.center,
                      clr: Colors.black,
                      size: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  questionsAndAnswers() {
    return Obx(
      () => businessController.faq.isNotEmpty
          ? Column(
              children: List.generate(businessController.faq.length,
                  (index) => getQuestions(index)),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/Search1.png',
                    width: 250,
                  ),
                ),
                Center(
                  child: CommenTextWidget(
                    s: 'No Results Have Been Found'.tr,
                    size: 17,
                    fs: FontStyle.normal,
                    fw: FontWeight.bold,
                    clr: Colr.primary,
                  ),
                ),
              ],
            ),
    );
  }

  getQuestions(int index) {
    return Obx(() => Column(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(getAnswers(
                        businessController.faq[index].questions,
                        businessController.faq[index].answers));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width / 2,
                        child: CommenTextWidget(
                          s: businessController.faq[index].questions,
                          size: 16,
                          fs: FontStyle.normal,
                          fw: FontWeight.normal,
                          clr: Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Divider()
          ],
        ));
  }

  Widget getAnswers(String question, String answer) {
    return Container(
      height: answer.length < 300
          ? 200
          : (answer.length > 300 && answer.length < 700)
              ? 400
              : null,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommenTextWidget(
                s: question,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
                clr: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              CommenTextWidget(
                s: answer,
                size: 16,
                fs: FontStyle.normal,
                fw: FontWeight.normal,
                clr: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

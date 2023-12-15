import 'package:B2C/controller/search_controller.dart' as ser;
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/view/screens/SearchScreen/search_view_screen.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/homescreen_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

// ignore: must_be_immutable
class SubCategoryScreen extends StatefulWidget {
  int? categoryId;
  String? categoryName;
  String? categoryNameH;
  String? fromScreen;

  // ignore: use_key_in_widget_constructors
  SubCategoryScreen(
      {this.categoryId,
      this.categoryName,
      this.categoryNameH,
      this.fromScreen});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final localizationController = Get.put(LocalizationController());
  final searchController = Get.put(ser.SearchController());

  bool isLoad = false;
  Future<void> fetchAPI() async {
    await homeScreenController.getAllSubCategories(widget.categoryId!);
    setState(() {
      isLoad = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          shadowColor: Colors.transparent,
          title: Text(
            localizationController.isHebrew.value
                ? widget.categoryNameH!
                : widget.categoryName!,
            style: const TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          // ignore: deprecated_member_use
          leading: localizationController.isHebrew.value ? null : iconButton(),
          actions: [
            localizationController.isHebrew.value ? iconButton() : Container()
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light),
      body: isLoad
          ? SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(homeScreenController.subCategories.length,
                  (index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        var subCategory = localizationController.isHebrew.value
                            ? homeScreenController
                                .subCategories[index].categoryNameH
                            : homeScreenController.subCategories[index].name;
                        searchController.subCategory.value = subCategory;

                        Get.off(SearchScreeanView(
                          searchKey: subCategory,
                        ));
                      },
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommenTextWidget(
                                s: localizationController.isHebrew.value
                                    ? homeScreenController
                                        .subCategories[index].categoryNameH
                                    : homeScreenController
                                        .subCategories[index].name
                                        .toCapitalCase(),
                                size: 16,
                                fs: FontStyle.normal,
                                fw: FontWeight.normal,
                                clr: Colors.black,
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
                    const Divider(
                      color: Color.fromARGB(255, 243, 241, 241),
                    )
                  ],
                );
              }),
            ))
          : Center(
              child: CircularProgressIndicator(
                color: Colr.primary,
              ),
            ),
    );
  }

  IconButton iconButton() {
    return IconButton(
      icon: Icon(
        localizationController.isHebrew.value
            ? Icons.arrow_forward_ios_outlined
            : Icons.arrow_back_ios_rounded,
        color: Colors.black,
        size: 16,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }
}

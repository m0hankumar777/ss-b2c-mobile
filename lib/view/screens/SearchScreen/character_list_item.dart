import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/model/Search/search_product_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// List item representing a single Character with its photo and name.

// ignore: must_be_immutable
class CharacterListItem extends StatelessWidget {
  CharacterListItem({
    required this.character,
    required this.localizationController,
    Key? key,
  }) : super(key: key);

  final SearchProductModel character;
  var localizationController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Get.height * 0.005),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: localizationController.isHebrew.value
                              ? EdgeInsets.only(left: Get.width * 0.04)
                              : EdgeInsets.only(right: Get.width * 0.04),
                          child: Container(
                            height: Get.height * 0.064,
                            width: Get.height * 0.064,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: character.isSearchRatedPlan
                                      ? Colr.primary
                                      : Colors.grey),
                              borderRadius:
                                  BorderRadius.circular(Get.height * 0.008),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(Get.width * 0.008),
                              key: Key(character.logoImageUrl),
                              height: Get.height * 0.054,
                              width: Get.height * 0.054,
                              // child: NetworkImageView(character: character)
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Get.height * 0.005),
                                image: DecorationImage(
                                  image: NetworkImage(character.logoImageUrl),
                                  opacity: 2.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommenTextWidget(
                                s: localizationController.isHebrew.value
                                    ? character.nameH
                                    : character.name,
                                size: 15,
                                fs: FontStyle.normal,
                                fw: FontWeight.bold,
                                clr: Colr.black1,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: CommenTextWidget(
                                      s: localizationController.isHebrew.value
                                          ? character.addressH
                                          : character.address,
                                      size: 12,
                                      fs: FontStyle.normal,
                                      fw: FontWeight.w400,
                                      clr: Colr.black1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment:
                                          localizationController.isHebrew.value
                                              ? Alignment.bottomLeft
                                              : Alignment.bottomRight,
                                      child: CommenTextWidget(
                                        s: "${character.distance} ${"Km".tr}",
                                        size: 12,
                                        fs: FontStyle.normal,
                                        fw: FontWeight.w400,
                                        clr: Colr.black1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

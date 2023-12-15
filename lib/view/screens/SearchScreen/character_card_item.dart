import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/model/Search/search_product_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// List item representing a single Character with its photo and name.

// ignore: must_be_immutable
class CharacterCardItem extends StatelessWidget {
  CharacterCardItem({
    required this.character,
    required this.localizationController,
    Key? key,
  }) : super(key: key);

  final SearchProductModel character;
  var localizationController = Get.put(LocalizationController());

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: character.isSearchRatedPlan
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colr.primary, width: 2.0),
                borderRadius: BorderRadius.circular(8.0))
            : RoundedRectangleBorder(
                side: BorderSide(color: Colr.primaryLight, width: 2.0),
                borderRadius: BorderRadius.circular(8.0)),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        key: Key(character.coverLogo1),
                        margin: const EdgeInsets.symmetric(),
                        height: Get.height * 0.24,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Get.height * 0.008),
                          image: character.coverLogo1 != ""
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(character.coverLogo1))
                              : const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/Glamz-cover.png')),

                          // DecorationImage(
                          //   image: NetworkImage(character.coverLogo1),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.height * 0.018,
                          vertical: Get.height * 0.018),
                      child: Container(
                        key: Key(character.logoImageUrl),
                        margin: EdgeInsets.only(top: Get.height * 0.14),
                        height: Get.height * 0.064,
                        width: Get.height * 0.064,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(Get.height * 0.008),
                          image: character.logoImageUrl != ""
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(character.logoImageUrl))
                              : const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/glamz-logo.png')),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0, vertical: Get.height * 0.007),
                    child: servicesHere()),
                // character.tagDetail != ''
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 0, vertical: Get.height * 0.007),
                //         child: tagsHere())
                //     : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5, vertical: Get.height * 0.001),
                  child: CommenTextWidget(
                    s: localizationController.isHebrew.value
                        ? character.nameH
                        : character.name,
                    size: 18,
                    fs: FontStyle.normal,
                    fw: FontWeight.w700,
                    clr: Colr.black1,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: localizationController.isHebrew.value
                          ? const EdgeInsets.fromLTRB(0, 5, 5, 5)
                          : const EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: CommenTextWidget(
                        s: localizationController.isHebrew.value
                            ? character.addressH
                            : character.address,
                        size: 12,
                        fs: FontStyle.normal,
                        fw: FontWeight.bold,
                        clr: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: localizationController.isHebrew.value
                          ? const EdgeInsets.only(right: 5.0)
                          : const EdgeInsets.only(left: 5.0),
                      child: circleIcon(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.013),
                      child: CommenTextWidget(
                        s: "${character.distance} ${"Km".tr}",
                        size: 12,
                        fs: FontStyle.normal,
                        fw: FontWeight.bold,
                        clr: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(' '),
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.013),
                          child: CommenTextWidget(
                            s: character.rating.toString(),
                            size: 12,
                            fs: FontStyle.normal,
                            fw: FontWeight.bold,
                            clr: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                /* Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Get.width * 0.013),
                        child: CommenTextWidget(
                          s: character.distance.toString() + " " + "Km".tr,
                          size: 12,
                          fs: FontStyle.normal,
                          fw: FontWeight.bold,
                          clr: Colors.grey,
                        ),
                      ),
                      circleIcon(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.013),
                        child: CommenTextWidget(
                          s: character.rating.toString(),
                          size: 12,
                          fs: FontStyle.normal,
                          fw: FontWeight.bold,
                          clr: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ), */
                Padding(
                  padding: EdgeInsets.fromLTRB(Get.width * 0.013, 0,
                      Get.width * 0.013, Get.width * 0.013),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          'assets/images/timer.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3.0,
                        ),
                        child: CommenTextWidget(
                          s: localizationController.isHebrew.value
                              ? ' ${character.toWorkinghrs} - ${character.fromWorkinghrs} '
                              : ' ${character.fromWorkinghrs} - ${character.toWorkinghrs} ',
                          size: 12,
                          fs: FontStyle.normal,
                          fw: FontWeight.bold,
                          clr: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  servicesHere() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            '  ${localizationController.isHebrew.value ? character.services[0].serviceNameH : character.services[0].serviceName}  ',
            style: const TextStyle(
                color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          character.services.length > 1 ? circleIcon() : Container(),
          character.services.length > 1
              ? Text(
                  '  ${localizationController.isHebrew.value ? character.services[1].serviceNameH : character.services[1].serviceName}  ',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )
              : const Text(''),
          character.services.length > 2 ? circleIcon() : Container(),
          character.services.length > 2
              ? Text(
                  '  ${localizationController.isHebrew.value ? character.services[2].serviceNameH : character.services[2].serviceName}  ',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )
              : const Text(''),
        ],
      ),
    );
  }

  tagsHere() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Text(
            '  ${localizationController.isHebrew.value ? character.tagDetailH : character.tagDetail}  ',
            style: const TextStyle(
                color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ]));
  }

  Icon circleIcon() {
    return const Icon(
      Icons.circle,
      size: 6,
      color: Colors.grey,
    );
  }
}

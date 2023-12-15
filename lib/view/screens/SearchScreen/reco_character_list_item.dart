import 'package:B2C/model/Home/home_recommendedsalons_model.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// List item representing a single Character with its photo and name.
class RecoCharacterListItem extends StatelessWidget {
  const RecoCharacterListItem({
    required this.character,
    Key? key,
  }) : super(key: key);

  final RecommendedSalonsModel character;

  @override
  Widget build(BuildContext context) {
    /* return ListTile(
      leading: Text("Hi , "),
      title: Text(character.name),
    ); */
    return Card(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, Get.height * 0.018,
                                Get.height * 0.018, Get.height * 0.018),
                            child: Container(
                              height: Get.height * 0.064,
                              width: Get.height * 0.064,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.circular(Get.height * 0.006),
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.005,
                              vertical: Get.height * 0.022,
                            ),
                            child: Container(
                              height: Get.height * 0.054,
                              width: Get.height * 0.054,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Get.height * 0.003),
                                image: DecorationImage(
                                  image: NetworkImage(character.profileImage),
                                  opacity: 2.0,
                                  fit: BoxFit.cover,
                                ),
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
                      CommenTextWidget(
                        s: character.name.tr,
                        size: 14,
                        fs: FontStyle.normal,
                        fw: FontWeight.bold,
                        clr: Colors.black,
                      ),
                      CommenTextWidget(
                        s: character.address.tr,
                        size: 12,
                        fs: FontStyle.normal,
                        fw: FontWeight.bold,
                        clr: Colors.black54,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.064,
              width: Get.height * 0.064,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CommenTextWidget(
                    s: '  '
                        '1.2 ק״מ'
                        '  ',
                    size: 12,
                    fs: FontStyle.normal,
                    fw: FontWeight.bold,
                    clr: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

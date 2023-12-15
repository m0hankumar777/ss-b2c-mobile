import 'package:B2C/model/Home/home_recommendedsalons_model.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// List item representing a single Character with its photo and name.
class RecoCharacterCardItem extends StatelessWidget {
  const RecoCharacterCardItem({
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
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(),
                  height: Get.height * 0.24,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Get.height * 0.006),
                    image: DecorationImage(
                      image: NetworkImage(character.profileImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.height * 0.018,
                      vertical: Get.height * 0.018),
                  child: Container(
                    margin: EdgeInsets.only(top: Get.height * 0.14),
                    height: Get.height * 0.064,
                    width: Get.height * 0.064,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(Get.height * 0.006),
                      image: DecorationImage(
                          image: NetworkImage(character.coverImage),
                          opacity: 2.0,
                          fit: BoxFit.cover,
                          scale: 2.0),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5, vertical: Get.height * 0.01),
              child: CommenTextWidget(
                s: character.name.tr,
                size: 12,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
                clr: Colors.grey[600],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5, vertical: Get.height * 0.005),
              child: CommenTextWidget(
                s: character.address.tr,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
                clr: Colors.black,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: CommenTextWidget(
                    s: character.address.tr,
                    size: 12,
                    fs: FontStyle.normal,
                    fw: FontWeight.bold,
                    clr: Colors.black,
                  ),
                ),
                circleIcon(),
                CommenTextWidget(
                  s: '  '
                      '1.2 ק״מ'
                      '  ',
                  size: 12,
                  fs: FontStyle.normal,
                  fw: FontWeight.bold,
                  clr: Colors.black,
                ),
                circleIcon(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: CommenTextWidget(
                    s: character.noofrating.toString(),
                    size: 12,
                    fs: FontStyle.normal,
                    fw: FontWeight.bold,
                    clr: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.star,
                  size: 12,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.history_sharp,
                    size: 16,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3.0,
                    ),
                    child: CommenTextWidget(
                      s: character.fromWorkinghrs,
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.bold,
                      clr: Colors.grey[600],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CommenTextWidget(
                      s: ' - '.tr,
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.bold,
                      clr: Colors.grey[800],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CommenTextWidget(
                      s: character.toWorkinghrs,
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.bold,
                      clr: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Icon circleIcon() {
    return const Icon(
      Icons.circle,
      size: 6,
      color: Colors.grey,
    );
  }
}

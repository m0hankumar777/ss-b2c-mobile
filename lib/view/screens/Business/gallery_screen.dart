import 'package:B2C/controller/homescreen_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/view/screens/Business/category_screen.dart';
import 'package:B2C/utility/images.dart' as images;
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/business_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

// ignore: must_be_immutable
class ShowImages extends StatefulWidget {
  int businessId;
  ShowImages(this.businessId, {super.key});

  @override
  State<ShowImages> createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  final homeScreenController = Get.put(HomeScreenController());
  final businessController = Get.put(BusinessController(), permanent: true);
  final localizationController = Get.put(LocalizationController());

  int _selectedIndex = -1;
  int catId = 2;
  bool isLoad = false;
  bool galleryAvailable = false;
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    await businessController.getAllCategoryImages(widget.businessId, 0);
    await businessController.getCategoryImages(widget.businessId, 2);
    if (mounted) {
      setState(() {
        isLoad = true;
        galleryAvailable = true;
        if (businessController.allGalleryImages.isEmpty) {
          setState(() {
            _selectedIndex = 0;
            catId = 2;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoad
            ? SingleChildScrollView(
                child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        businessController.allGalleryImages.isNotEmpty
                            ? forAllGalleryImages(context)
                            : Container(),
                        CategoriesSlider(context),
                      ],
                    )),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                galleryAvailable
                    ? Column(
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: (_selectedIndex == -1 &&
                                      businessController
                                          .allGalleryImages.isNotEmpty)
                                  ? allGallery()
                                  : gallery()),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: businessController.categoryImages.isEmpty
                            ? noImage()
                            : Center(
                                child: CircularProgressIndicator(
                                    color: Colr.primary)),
                      ),
                const SizedBox(
                  height: 50,
                ),
              ]))
            : Center(
                child: CircularProgressIndicator(color: Colr.primary),
              ));
  }

  SizedBox forAllGalleryImages(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: InkWell(
        onTap: () async {
          setState(() {
            galleryAvailable = false;
            _selectedIndex = -1;
            catId = 0;
          });
          await businessController
              .getAllCategoryImages(widget.businessId, 0)
              .then((value) {
            setState(() {
              galleryAvailable = true;
            });
          });
        },
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: CircleAvatar(
                radius: _selectedIndex == -1 ? 35 : 40,
                backgroundColor:
                    _selectedIndex == -1 ? Colr.primary : Colors.transparent,
                child: Icon(
                  Icons.reviews,
                  color:
                      _selectedIndex == -1 ? Colr.primaryLight : Colr.primary,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: CommenTextWidget(
                  s: "All Images".tr,
                  align: TextAlign.center,
                  clr: Colors.black,
                  size: 12),
            ),
          ],
        ),
      ),
    );
  }

  gallery() {
    return businessController.categoryImages.isNotEmpty
        ? Wrap(
            runSpacing: 15,
            spacing: Get.width * 0.0125,
            children: List.generate(businessController.categoryImages.length,
                (index) {
              return InkWell(
                onTap: () {
                  Get.to(() => CategoryImages(index, widget.businessId, catId));
                },
                child: Container(
                  height: Get.width * 0.45,
                  width: Get.width * 0.45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: (businessController
                                      .categoryImages[index].imageUrl !=
                                  null ||
                              businessController
                                      .categoryImages[index].imageUrl !=
                                  "")
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(businessController
                                  .categoryImages[index].imageUrl!))
                          : const DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/images/glamz-logo.png'))),
                ),
              );
            }))
        // GridView(
        //     physics: const NeverScrollableScrollPhysics(),
        //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //         maxCrossAxisExtent: Get.width * .5,
        //         childAspectRatio: 1,
        //         mainAxisExtent: 180,
        //         crossAxisSpacing: 20,
        //         mainAxisSpacing: 20),
        //     children: List.generate(
        //         growable: true,
        //         businessController.categoryImages.length,
        //         (index) => InkWell(
        //               onTap: () {
        //                 Get.to(() =>
        //                     CategoryImages(index, widget.businessId, catId));
        //               },
        //               child: Container(
        //                 alignment: Alignment.center,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(15),
        //                     image: (businessController
        //                                     .categoryImages[index].imageUrl !=
        //                                 null ||
        //                             businessController
        //                                     .categoryImages[index].imageUrl !=
        //                                 "")
        //                         ? DecorationImage(
        //                             fit: BoxFit.cover,
        //                             image: NetworkImage(businessController
        //                                 .categoryImages[index].imageUrl!))
        //                         : const DecorationImage(
        //                             fit: BoxFit.cover,
        //                             image: AssetImage(
        //                                 'assets/images/glamz-logo.png'))),
        //               ),
        //             )),
        //   )
        // ? GridView.builder(
        //     //physics: const NeverScrollableScrollPhysics(),
        //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        //         maxCrossAxisExtent: Get.width * .5,
        //         childAspectRatio: 1,
        //         mainAxisExtent: 180,
        //         crossAxisSpacing: 20,
        //         mainAxisSpacing: 20),
        //     itemCount: businessController.categoryImages.length,
        //     itemBuilder: (context, index) {
        //       return InkWell(
        //         onTap: () {
        //           Get.to(() => CategoryImages(index, widget.businessId, catId));
        //         },
        //         child: Container(
        //           alignment: Alignment.center,
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(15),
        //               image: (businessController
        //                               .categoryImages[index].imageUrl !=
        //                           null ||
        //                       businessController
        //                               .categoryImages[index].imageUrl !=
        //                           "")
        //                   ? DecorationImage(
        //                       fit: BoxFit.cover,
        //                       image: NetworkImage(businessController
        //                           .categoryImages[index].imageUrl!))
        //                   : const DecorationImage(
        //                       fit: BoxFit.cover,
        //                       image:
        //                           AssetImage('assets/images/glamz-logo.png'))),
        //         ),
        //       );
        //     })
        : noImage();
  }

  allGallery() {
    return Wrap(
        runSpacing: 15,
        spacing: Get.width * 0.0125,
        children:
            List.generate(businessController.allGalleryImages.length, (index) {
          return InkWell(
            onTap: () {
              Get.to(CategoryImages(index, widget.businessId, 0));
            },
            child: Container(
              height: Get.width * 0.45,
              width: Get.width * 0.45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: (businessController.allGalleryImages[index].imageUrl !=
                              null ||
                          businessController.allGalleryImages[index].imageUrl !=
                              "")
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(businessController
                              .allGalleryImages[index].imageUrl!))
                      : const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/glamz-logo.png'))),
            ),
          );
        }));
  }

  noImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: 250, child: Image.asset('assets/images/noImageFound.png')),
        ),
        CommenTextWidget(
          clr: Colr.primary,
          size: 18,
          s: "No Image Found".tr,
          fw: FontWeight.bold,
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox CategoriesSlider(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
            children:
                List.generate(homeScreenController.categories.length, (index) {
          return InkWell(
            onTap: () async {
              setState(() {
                galleryAvailable = false;
                _selectedIndex = index;
                catId = homeScreenController.categories[index].id;
              });
              await businessController
                  .getCategoryImages(widget.businessId,
                      homeScreenController.categories[index].id)
                  .then((value) {
                if (businessController.categoryImages.isNotEmpty) {
                  setState(() {
                    galleryAvailable = true;
                  });
                }
              });
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
        })));
  }
}

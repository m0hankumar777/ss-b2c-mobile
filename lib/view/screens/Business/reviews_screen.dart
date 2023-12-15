import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/business_controller.dart';
import '../../../controller/homescreen_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/customer_controller.dart';
import '../../../utility/themes_b2c.dart';
import 'package:B2C/utility/images.dart' as images;
import '../../../controller/login_controller.dart' as login;

import '../../../utility/widget_helper/common_text_widget.dart';

// ignore: must_be_immutable
class ReviewsScreen extends StatefulWidget {
  int businessId;

  ReviewsScreen(this.businessId, {super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final businessController = Get.put(BusinessController());
  final custController = Get.put(CustomerController());
  final localizationController = Get.put(LocalizationController());
  final reviewsController = TextEditingController();

  int? _selectedIndex = -1;
  bool isLoad = false;
  bool reviewsAvailable = false;
  int reviewRating = 0;
  int catId = 0;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    await homeScreenController.getAllCategories();
    await businessController.getAllReviews(widget.businessId, 0);
    await businessController.getReviews(widget.businessId, 2);
    setState(() {
      isLoad = true;
      reviewsAvailable = true;
      isLogin = login.getLoginStatus();
      if (businessController.allReviews.isEmpty) {
        setState(() {
          _selectedIndex = 0;
          catId = 2;
        });
      }
    });
    if (isLogin) {
      custController.getUserInformation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (catId != 0)
          ? FloatingActionButton(
              backgroundColor: Colr.primary,
              onPressed: () {
                reviewsController.clear();
                reviewRating = 0;
                isLogin
                    ? Get.bottomSheet(reviewWidget(
                        'Please leave your review so other people know your opinion'
                            .tr))
                    : Get.to(HomeScreen(selectedIndex: 0));
              },
              child: const Icon(Icons.rate_review))
          : null,
      body: isLoad
          ? SingleChildScrollView(
              child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ), //top level space
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      businessController.allReviews.isNotEmpty
                          ? forAllReviews(context)
                          : Container(),
                      CategoriesSlider(context),
                    ],
                  ),
                ),
                const Divider(
                  height: 2,
                ),
                reviewsAvailable
                    ? (_selectedIndex == -1 &&
                            businessController.allReviews.isNotEmpty)
                        ? getAllReviews()
                        : getReviews()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(color: Colr.primary),
                        ),
                      ),
              ],
            ))
          : Center(
              child: CircularProgressIndicator(color: Colr.primary),
            ),
    );
  }

  SizedBox forAllReviews(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: InkWell(
        onTap: () async {
          setState(() {
            reviewsAvailable = false;
            _selectedIndex = -1;
            catId = 0;
          });
          await businessController
              .getAllReviews(widget.businessId, 0)
              .then((value) {
            setState(() {
              reviewsAvailable = true;
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
                  s: "All Reviews".tr,
                  align: TextAlign.center,
                  clr: Colors.black,
                  size: 12),
            ),
          ],
        ),
      ),
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
                reviewsAvailable = false;
                _selectedIndex = index;
                catId = homeScreenController.categories[index].id;
              });
              await businessController
                  .getReviews(widget.businessId,
                      homeScreenController.categories[index].id)
                  .then((value) {
                setState(() {
                  reviewsAvailable = true;
                });
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

  getReviews() {
    return businessController.reviews.isNotEmpty
        ? Obx(() => Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                      child: Column(
                    children: List.generate(businessController.reviews.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                width: 60,
                                height: 65,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    image: (businessController
                                                    .reviews[index].imageUrl !=
                                                null ||
                                            businessController
                                                    .reviews[index].imageUrl !=
                                                "")
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                businessController
                                                    .reviews[index].imageUrl!))
                                        : const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'assets/images/glamz-logo.png'))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: SizedBox(
                                  width: 200,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommenTextWidget(
                                            s: businessController
                                                .reviews[index].clientName
                                                .toString(),
                                            clr: Colors.black,
                                            size: 18,
                                            fw: FontWeight.w500),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CommenTextWidget(
                                            s: DateFormat('dd.MM.yyyy').format(
                                                businessController
                                                    .reviews[index]
                                                    .publishedDate!),
                                            clr: Colors.black54,
                                            size: 14,
                                            fw: FontWeight.w400),
                                      ]),
                                ),
                              )
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: Get.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ratingWidget(
                                      businessController.reviews[index].rating),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: SizedBox(
                                      width: 250,
                                      child: CommenTextWidget(
                                          s: businessController
                                              .reviews[index].reviewText!,
                                          clr: Colors.black,
                                          size: 13,
                                          fw: FontWeight.w400),
                                    ),
                                  ),
                                  const Divider(),
                                  businessController.reviews[index].replyText !=
                                              null &&
                                          businessController
                                                  .reviews[index].replyText !=
                                              ''
                                      ? Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              color: const Color.fromARGB(
                                                  255, 240, 239, 239),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                child: CommenTextWidget(
                                                  s: businessController
                                                      .reviews[index]
                                                      .replyText!,
                                                  size: 10,
                                                  fw: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            const Divider()
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )),
                ),
              ],
            ))
        : noImage();
  }

  getAllReviews() {
    return businessController.allReviews.isNotEmpty
        ? Obx(() => Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                      child: Column(
                    children: List.generate(
                        businessController.allReviews.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                width: 60,
                                height: 65,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    image: businessController
                                                .allReviews[index].imageUrl !=
                                            ''
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                businessController
                                                    .allReviews[index]
                                                    .imageUrl!))
                                        : const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'assets/images/glamz-logo.png'))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: SizedBox(
                                  width: 200,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommenTextWidget(
                                            s: businessController
                                                    .allReviews[index]
                                                    .clientName ??
                                                '',
                                            clr: Colors.black,
                                            size: 18,
                                            fw: FontWeight.w500),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CommenTextWidget(
                                            s: DateFormat('dd-MM-yyyy').format(
                                                businessController
                                                    .allReviews[index]
                                                    .publishedDate!),
                                            clr: Colors.black54,
                                            size: 14,
                                            fw: FontWeight.w600),
                                      ]),
                                ),
                              )
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ratingWidget(businessController
                                      .allReviews[index].rating),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: SizedBox(
                                      width: 250,
                                      child: CommenTextWidget(
                                          s: businessController
                                                      .allReviews[index]
                                                      .reviewText !=
                                                  null
                                              ? businessController
                                                  .allReviews[index].reviewText!
                                              : '',
                                          clr: Colors.black,
                                          size: 13,
                                          fw: FontWeight.w200),
                                    ),
                                  ),
                                  (businessController
                                              .allReviews[index].replyText !=
                                          null)
                                      ? Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              color: const Color.fromARGB(
                                                  255, 240, 239, 239),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                child: CommenTextWidget(
                                                  s: businessController
                                                      .allReviews[index]
                                                      .replyText!,
                                                  size: 10,
                                                  fw: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            const Divider()
                                          ],
                                        )
                                      : Container(),
                                  const Divider()
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )),
                ),
              ],
            ))
        : noImage();
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
          child: Image.asset(
            'assets/images/no_reviews.png',
            width: 250,
          ),
        ),
        CommenTextWidget(
          clr: Colr.primary,
          size: 18,
          s: "No Results Have Been Found".tr,
          fw: FontWeight.bold,
        )
      ],
    );
  }

  ratingWidget(rating) {
    return RatingBar.builder(
      itemSize: 20,
      itemBuilder: (context, index) {
        return Icon(
          Icons.star,
          color: Colr.primary,
        );
      },
      ignoreGestures: true,
      initialRating: rating.toDouble(),
      unratedColor: Colors.grey,
      updateOnDrag: false,
      glow: false,
      onRatingUpdate: (double value) {},
    );
  }

  Container reviewWidget(String bbody) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/congragulation.png"))),
                ),
                Positioned(
                  top: 15,
                  left: 20,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colr.primary,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colr.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: CommenTextWidget(
                  s: bbody,
                  size: 16,
                  clr: Colors.black54,
                  align: TextAlign.center,
                )),
            const SizedBox(
              height: 10,
            ),
            ratingBarWidget(),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 203, 200),
                  border: Border.all(color: Colors.red),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                controller: reviewsController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                minLines: 2,
              ),
            ),
            InkWell(
              onTap: () async {
                if (reviewRating != 0) {
                  if (reviewsController.text != '') {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return SizedBox(
                            height: 50,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colr.primary,
                            )));
                      },
                    );
                    Future.delayed(const Duration(seconds: 4), () async {
                      Navigator.pop(context); //pop dialog
                    }).then((value) async {
                      Map reviewsMap = {
                        "reviews": reviewsController.text,
                        "categoryId": catId,
                        "ratings": reviewRating.toString(),
                        "customerId": custController.custInfo.value.id,
                        "businessId": widget.businessId.toString(),
                        "currentDate": DateTime.now().toIso8601String()
                      };
                      await businessController
                          .reviewValidate(widget.businessId,custController.custInfo.value.id!)
                          .then((value) async => {
                                if (value == true)
                                  {
                                    await businessController
                                        .postReviews(reviewsMap)
                                        .then((value) {
                                      if (value == 200) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Review added successfully'.tr);
                                      }
                                    })
                                  }
                                else
                                  {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Customer can write a review , only if they have an appointment in the salon'
                                                .tr)
                                  }
                              });

                      Get.back();
                    });
                  } else {
                    Fluttertoast.showToast(msg: 'Add Review'.tr);
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Give Rating'.tr);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colr.primary,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child:
                            CommenTextWidget(s: 'Submit'.tr, clr: Colors.white),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ratingBarWidget() {
    return RatingBar.builder(
      itemSize: 30,
      itemBuilder: (context, index) {
        return Icon(
          Icons.star,
          color: Colr.primary,
        );
      },
      onRatingUpdate: (value) {
        setState(() {
          reviewRating = value.toInt();
        });
      },
      unratedColor: Colors.grey,
      updateOnDrag: true,
      glow: false,
      allowHalfRating: false,
    );
  }
}

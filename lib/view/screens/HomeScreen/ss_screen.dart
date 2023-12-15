import 'dart:async';
import 'package:B2C/controller/appointmentlist_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/view/screens/Business/business_about_screen.dart';
import 'package:B2C/view/screens/HomeScreen/sub_category_screen.dart';
import 'package:B2C/view/screens/SearchScreen/search_view_screen.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../../../controller/customer_controller.dart';
import '../../../controller/homescreen_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../utility/widget_helper/common_text_widget.dart';
import '../../../utility/images.dart' as images;
import '../../../utility/ui_helper.dart' as image;
import 'package:B2C/controller/login_controller.dart' as loginauth;

class GlamzScreen extends StatefulWidget {
  const GlamzScreen({super.key});

  @override
  State<GlamzScreen> createState() => _GlamzScreenState();
}

class _GlamzScreenState extends State<GlamzScreen> {
  Location location = Location();
  final homeScreenController = Get.put(HomeScreenController());
  final localizationController = Get.put(LocalizationController());
  final customerController = Get.put(CustomerController());
  final notificationsController = Get.put(HomeScreenController());
  final appointmentListController = Get.put(AppointmentListController());

  // ignore: prefer_typing_uninitialized_variables
  double lat = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  double long = 0.0;
  RxBool isGpsOn = true.obs;
  bool isLogin = loginauth.getLoginStatus();
  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    await homeScreenController.getRecommendedSalons(lat, long);
    getCurrentLocation().then((value) async =>
        await homeScreenController.getRecommendedSalons(lat, long));
    await homeScreenController.getAllCategories();
    await homeScreenController.getClientReviewCount();
    await homeScreenController.getClientReviews();
    if (customerController.custInfo.value.id != null) {
      await homeScreenController
          .getAllNotifications(customerController.custInfo.value.id!);
    }
    if (isLogin) {
      await customerController.getUserInformation();
    }
    if (customerController.custInfo.value.id != null) {
      await notificationsController
          .getUnreadNotificationsCount(customerController.custInfo.value.id!);
      await appointmentListController
          .getFutureAppointmentCountList(customerController.custInfo.value.id!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colr.primary,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    searchBarWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              getCategories(),
              const SizedBox(
                height: 10,
              ),
              getCategoriesSlider(),
              const SizedBox(
                height: 20,
              ),
              getPopularServices(),
              getRecommendationSalons(),
              getVerifiedIcons(),
              const SizedBox(
                height: 20,
              ),
              getClientReviews(),
              const SizedBox(
                height: 20,
              ),
              getReviews(),
              const SizedBox(
                height: 30,
              )
            ]),
      ),
    );
  }

  searchBarWidget() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                Get.to(() => SearchScreeanView());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommenTextWidget(
                        s: 'Search By Service or Salon'.tr,
                        clr: Colors.grey,
                        size: 16,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/search.png'))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getCategories() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommenTextWidget(
                s: 'Categories'.tr,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
                clr: Colors.black,
              ),
              InkWell(
                onTap: () {
                  Get.bottomSheet(getAllCategories());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromRGBO(211, 51, 69, 0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommenTextWidget(
                      s: 'View all'.tr,
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.normal,
                      clr: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  getCategoriesSlider() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(homeScreenController.categories.length,
                  (index) {
            return InkWell(
              onTap: () {
                Get.to(() => SubCategoryScreen(
                    categoryId: homeScreenController.categories[index].id,
                    categoryName: homeScreenController.categories[index].name
                        .toCapitalCase(),
                    categoryNameH:
                        homeScreenController.categories[index].categoryNameH));
              },
              child: SizedBox(
                width: 85,
                height: 130,
                child: Column(children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 37,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(images.categoryImages[index]),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CommenTextWidget(
                      s: localizationController.isHebrew.value
                          ? homeScreenController.categories[index].categoryNameH
                          : homeScreenController.categories[index].name
                              .toCapitalCase(),
                      align: TextAlign.center,
                      clr: Colors.black,
                      mxL: 2,
                      of: TextOverflow.ellipsis,
                      size: 13),
                ]),
              ),
            );
          })),
        ));
  }

  getPopularServices() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CommenTextWidget(
              s: 'Popular Services'.tr,
              size: 18,
              fs: FontStyle.normal,
              fw: FontWeight.bold,
              clr: Colors.black,
            )),
        const SizedBox(
          height: 10,
        ),
        getPopularServicesAvailable(),
      ],
    );
  }

  getPopularServicesAvailable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(8, (index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => SearchScreeanView(
                        searchKey: localizationController.isHebrew.value
                            ? image.PopularServiceNameH[index]
                            : image.PopularServiceName[index],
                      ));
                },
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  elevation: 3,
                  child: SizedBox(
                    width: 140,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage(images.popularServiceImage[index]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommenTextWidget(
                              s: localizationController.isHebrew.value
                                  ? image.PopularServiceNameH[index]
                                  : image.PopularServiceName[index],
                              clr: Colors.black,
                              size: 13,
                              mxL: 1,
                              of: TextOverflow.ellipsis,
                              align: TextAlign.center,
                              fw: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        })),
      ),
    );
  }

  getRecommendationSalons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        recommendedSalonsTitle(),
        recommendedSalonsWidget(),
      ],
    );
  }

  recommendedSalonsTitle() {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: CommenTextWidget(
          s: homeScreenController.recommendedSalons.isNotEmpty
              ? 'Recommended Salons'.tr
              : '',
          size: 18,
          fs: FontStyle.normal,
          fw: FontWeight.bold,
          clr: Colors.black,
        )));
  }

  recommendedSalonsWidget() {
    return Obx(() => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        homeScreenController.recommendedSalons.length, (index) {
                      return InkWell(
                        onTap: () async {
                          Get.to(() => BusinessAboutScreen(
                              homeScreenController.recommendedSalons[index].id,
                              true));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Stack(children: [
                                Container(
                                  width: 300,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10),
                                      image: homeScreenController
                                                  .recommendedSalons[index]
                                                  .coverImage !=
                                              ''
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  homeScreenController
                                                      .recommendedSalons[index]
                                                      .coverImage))
                                          : const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "assets/images/Glamz-cover.png"))),
                                ),
                                Positioned(
                                    bottom: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: homeScreenController
                                                        .recommendedSalons[
                                                            index]
                                                        .profileImage !=
                                                    ''
                                                ? DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        homeScreenController
                                                            .recommendedSalons[
                                                                index]
                                                            .profileImage))
                                                : const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/images/glamz-logo.png")),
                                          )),
                                    ))
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 303,
                                child: servicesHere(index),
                              ),
                              SizedBox(
                                width: 300,
                                height: 135,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          child: SizedBox(
                                            width: 200,
                                            child: CommenTextWidget(
                                                s: homeScreenController
                                                    .recommendedSalons[index]
                                                    .name,
                                                clr: Colors.black,
                                                size: 20,
                                                fw: FontWeight.w900),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  'assets/images/location.png',
                                                ),
                                              ),
                                              SizedBox(
                                                width: 250,
                                                child: CommenTextWidget(
                                                    s: ' ${homeScreenController.recommendedSalons[index].address}  ',
                                                    clr: Colors.black54,
                                                    size: 14,
                                                    mxL: 1,
                                                    // of: TextOverflow.ellipsis,
                                                    fw: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  'assets/images/timer.png',
                                                ),
                                              ),
                                              (homeScreenController
                                                          .recommendedSalons[
                                                              index]
                                                          .fromWorkinghrs !=
                                                      'NULL')
                                                  ? CommenTextWidget(
                                                      s: localizationController
                                                              .isHebrew.value
                                                          ? ' ${homeScreenController.recommendedSalons[index].toWorkinghrs} - ${homeScreenController.recommendedSalons[index].fromWorkinghrs} '
                                                          : ' ${homeScreenController.recommendedSalons[index].fromWorkinghrs} - ${homeScreenController.recommendedSalons[index].toWorkinghrs} ',
                                                      align: TextAlign.left,
                                                      clr: Colors.black54,
                                                      size: 14,
                                                      fw: FontWeight.w400)
                                                  : CommenTextWidget(
                                                      s: ' ${'Closed'.tr}',
                                                      clr: Colors.red,
                                                      size: 14,
                                                      fw: FontWeight.normal),
                                              const Text('  '),
                                              circleIcon(),
                                              const Text('  '),
                                              CommenTextWidget(
                                                  s: '${homeScreenController.recommendedSalons[index].distance} '
                                                      '${'Km'.tr} ',
                                                  align: TextAlign.left,
                                                  clr: Colors.black54,
                                                  size: 14,
                                                  fw: FontWeight.w400),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  'assets/images/star.png',
                                                ),
                                              ),
                                              const Text('  '),
                                              CommenTextWidget(
                                                  s: '${homeScreenController.recommendedSalons[index].totalrating}',
                                                  align: TextAlign.left,
                                                  clr: Colors.black54,
                                                  size: 14,
                                                  fw: FontWeight.w400),
                                              const Text('  '),
                                              const Icon(
                                                Icons.circle,
                                                size: 6,
                                                color: Colors.grey,
                                              ),
                                              const Text('  '),
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  'assets/images/message.png',
                                                ),
                                              ),
                                              CommenTextWidget(
                                                  s: ' ${homeScreenController.recommendedSalons[index].noofrating} ',
                                                  align: TextAlign.left,
                                                  clr: Colors.black54,
                                                  size: 14,
                                                  fw: FontWeight.w400),
                                            ],
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
                      );
                    }),
                  )),
            )
          ],
        ));
  }

  Future<bool> enableBackgroundMode() async {
    bool bgModeEnabled = await location.isBackgroundModeEnabled();
    if (bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      return bgModeEnabled;
    }
  }

  Future getCurrentLocation() async {
    LocationData? currentLocation;
    enableBackgroundMode();

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {}
    }
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    if (serviceEnabled) {
      var location = Location();
      try {
        // Find and store your location in a variable
        currentLocation = await location.getLocation();
      } on Exception {
        currentLocation = null;
      }
      if (currentLocation != null) {
        lat = currentLocation.latitude!;
        long = currentLocation.longitude!;
      }
    }
  }

  servicesHere(int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CommenTextWidget(
              s: localizationController.isHebrew.value
                  ? '  ${homeScreenController.recommendedSalons[index].services[0].serviceNameH}  '
                  : '  ${homeScreenController.recommendedSalons[index].services[0].serviceName}  ',
              clr: Colors.grey,
              size: 13,
              fw: FontWeight.bold),
          homeScreenController.recommendedSalons[index].services.length > 1
              ? circleIcon()
              : Container(),
          homeScreenController.recommendedSalons[index].services.length > 1
              ? CommenTextWidget(
                  s: localizationController.isHebrew.value
                      ? '  ${homeScreenController.recommendedSalons[index].services[1].serviceNameH}  '
                      : '  ${homeScreenController.recommendedSalons[index].services[1].serviceName}  ',
                  clr: Colors.grey,
                  size: 13,
                  fw: FontWeight.bold)
              : const Text(''),
          homeScreenController.recommendedSalons[index].services.length > 2
              ? circleIcon()
              : Container(),
          homeScreenController.recommendedSalons[index].services.length > 2
              ? CommenTextWidget(
                  s: localizationController.isHebrew.value
                      ? '  ${homeScreenController.recommendedSalons[index].services[2].serviceNameH}  '
                      : '  ${homeScreenController.recommendedSalons[index].services[2].serviceName}  ',
                  clr: Colors.grey,
                  size: 13,
                  fw: FontWeight.bold)
              : const Text(''),
        ],
      ),
    );
  }

  Icon circleIcon() {
    return const Icon(
      Icons.circle,
      size: 6,
      color: Colors.grey,
    );
  }

  ratingWidget(topStaff) {
    return RatingBar.builder(
      itemSize: 20,
      itemBuilder: (context, index) {
        return const Icon(
          Icons.star,
          color: Colors.orange,
        );
      },
      initialRating: topStaff.toDouble(),
      unratedColor: Colors.grey,
      updateOnDrag: true,
      glow: false,
      allowHalfRating: true,
      onRatingUpdate: (double value) {},
    );
  }

  getVerifiedIcons() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(255, 249, 244, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                localizationController.isHebrew.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          height: 30,
                          width: Get.width * 0.4,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/home_GLAMZ.png'))),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CommenTextWidget(
                          s: '  ${'Why GLAMZ?'}',
                          size: 20,
                          fs: FontStyle.normal,
                          fw: FontWeight.bold,
                          clr: Colr.primary,
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                        height: 20,
                        child: Image(
                            image: AssetImage(
                          'assets/images/why-1.png',
                        ))),
                    CommenTextWidget(
                      s: '  ${'Only the best salons'.tr}',
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.normal,
                      clr: Colr.primary,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                        height: 20,
                        width: 20,
                        child: Image(
                            image: AssetImage(
                          'assets/images/why-2.png',
                        ))),
                    CommenTextWidget(
                      s: '  ${'Easily find  salons nearby'.tr}',
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.normal,
                      clr: Colr.primary,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                        height: 20,
                        width: 20,
                        child: Image(
                            image: AssetImage(
                          'assets/images/why-3.png',
                        ))),
                    CommenTextWidget(
                      s: '  ${'Appointments at your fingertips'.tr}',
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.normal,
                      clr: Colr.primary,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                    height: 150,
                    width: Get.width / 3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/home_image.png'))))
              ],
            ),
          ],
        ),
      ),
    );
  }

  getClientReviews() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: CommenTextWidget(
            s: '${'Client Reviews'.tr}  ${homeScreenController.clientCount} ',
            size: 18,
            fs: FontStyle.normal,
            fw: FontWeight.bold,
            clr: Colors.black,
          ),
        ));
  }

  getReviews() {
    return Obx(() => Column(
          children: [
            Container(
              height: 210,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        homeScreenController.clientReviews.length, (index) {
                      return homeScreenController
                              .clientReviews[index].reviewText.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                Get.to(() => BusinessAboutScreen(
                                    homeScreenController
                                        .clientReviews[index].customerId,
                                    true));
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 65,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: homeScreenController
                                                            .clientReviews[
                                                                index]
                                                            .imageUrl !=
                                                        ''
                                                    ? DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            homeScreenController
                                                                .clientReviews[
                                                                    index]
                                                                .imageUrl))
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
                                                        s: homeScreenController
                                                            .clientReviews[
                                                                index]
                                                            .salonName,
                                                        of: TextOverflow
                                                            .ellipsis,
                                                        mxL: 1,
                                                        clr: Colors.black,
                                                        size: 18,
                                                        fw: FontWeight.w500),
                                                    CommenTextWidget(
                                                      s: localizationController
                                                              .isHebrew.value
                                                          ? homeScreenController
                                                              .clientReviews[
                                                                  index]
                                                              .addressE
                                                          : homeScreenController
                                                              .clientReviews[
                                                                  index]
                                                              .address,
                                                      of: TextOverflow.ellipsis,
                                                      clr: Colors.black54,
                                                      size: 14,
                                                      fw: FontWeight.w300,
                                                      mxL: 2,
                                                    ),
                                                  ]),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children:
                                                  List.generate(5, ((index) {
                                                return starIcon();
                                              })),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                              child: SizedBox(
                                                width: 250,
                                                child: CommenTextWidget(
                                                    s: homeScreenController
                                                            .clientReviews[
                                                                index]
                                                            .reviewText
                                                            .isEmpty
                                                        ? ' '
                                                        : homeScreenController
                                                            .clientReviews[
                                                                index]
                                                            .reviewText,
                                                    of: TextOverflow.ellipsis,
                                                    // textAlign: TextAlign.left,
                                                    clr: Colors.black,
                                                    mxL: 2,
                                                    size: 13,
                                                    fw: FontWeight.w200),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container();
                    }),
                  )),
            )
          ],
        ));
  }

  Icon starIcon() {
    return Icon(
      Icons.star,
      size: 25,
      color: Colr.primary,
    );
  }

  getAllCategories() {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: CommenTextWidget(
                    s: "Categories".tr,
                    fw: FontWeight.bold,
                    size: 20,
                    clr: Colors.black),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(homeScreenController.categories.length,
                  (index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => SubCategoryScreen(
                            categoryId:
                                homeScreenController.categories[index].id,
                            categoryName: homeScreenController
                                .categories[index].name
                                .toCapitalCase(),
                            categoryNameH: homeScreenController
                                .categories[index].categoryNameH));
                      },
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommenTextWidget(
                                s: localizationController.isHebrew.value
                                    ? homeScreenController
                                        .categories[index].categoryNameH
                                    : homeScreenController
                                        .categories[index].name
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
            )
          ],
        ),
      ),
    );
  }
}

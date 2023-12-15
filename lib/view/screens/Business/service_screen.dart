// ignore_for_file: unnecessary_null_comparison

import 'dart:core';

import 'package:B2C/controller/book_appointment_controller.dart';
import 'package:B2C/controller/business_controller.dart';
import 'package:B2C/controller/homescreen_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/controller/login_controller.dart';
import 'package:B2C/controller/profile_controller.dart';
import 'package:B2C/model/Business/Services/business_subcategory_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/utility/widget_helper/common_elevated_button.dart';
import 'package:B2C/view/screens/BookAppointment/select_staff_and_timing_screen.dart';
import 'package:B2C/view/screens/BookAppointment/yaad_pay_screen.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:B2C/utility/images.dart' as images;

import '../HomeScreen/home_screen.dart';

// ignore: must_be_immutable
class ServiceScreen extends StatefulWidget {
  int? buisnessId;
  bool? canClear;

  ServiceScreen({super.key, this.buisnessId, this.canClear});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final homeScreenController = Get.put(HomeScreenController());
  final localizationController = Get.put(LocalizationController());
  final businessController = Get.put(BusinessController());
  final bookAppointmentController = Get.put(BookAppointmentController());
  final profileController = Get.put(ProfileController());
  final loginController = Get.put(LoginController());
  int? _selectedIndex = 0;

  bool isLoad = false;

  // ignore: unused_field
  final List<ServiceList> _selectedList = [];
  List<Object> values = [];
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void toggleSelectedListTile(
    ServiceList serviceList,
    SubCategoryModel subCategoryModel,
  ) {
    var isExists = bookAppointmentController.addedServices
        .map((item) => item.services.serviceId)
        .contains(serviceList.serviceId);

    if (isExists) {
      setState(() {
        bookAppointmentController.addedServices.removeWhere(
            (element) => element.services.serviceId == serviceList.serviceId);
      });
    } else {
      setState(() {
        bookAppointmentController.addedServices.add(AddedServiceModel(
            subcategory: subCategoryModel, services: serviceList));
      });
    }
  }

  void togglesubServiceSelectedListTile(SubServiceList subServiceList,
      SubCategoryModel subCategoryModel, ServiceList serviceList) {
    var isExists = bookAppointmentController.addedSubServices
        .map((item) => item.subService.subServiceId)
        .contains(subServiceList.subServiceId);

    if (isExists) {
      setState(() {
        bookAppointmentController.addedSubServices.removeWhere((element) =>
            element.subService.subServiceId == subServiceList.subServiceId);
        bookAppointmentController.addedSubServices
            .removeWhere((element) => element.subService == subServiceList);
      });
    } else {
      setState(() {
        bookAppointmentController.addedSubServices.add(AddedSubServiceModel(
            subcategory: subCategoryModel,
            services: serviceList,
            subService: subServiceList));
      });
    }
    setState(() {});
  }

  // getSpentTotal() {
  //   setState(() {
  //     sums = _selectedList.fold(0, (i, el) {
  //           return i + el.price.toInt();
  //         }) +
  //         _subServiceList.fold(0, (i, el) {
  //           return i + el.price.toInt();
  //         });
  //     totalValue = sums;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    if (widget.canClear!) {
      bookAppointmentController.clearAddedService();
    }
    await businessController.getAllSubCategoriesServices(
      widget.buisnessId!,
      2,
    );
    await homeScreenController.getAllCategories();

    if (mounted) {
      setState(() {
        isLoad = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: (bookAppointmentController.addedSubServices.length +
                  bookAppointmentController.addedServices.length >
              0)
          ? noOfServices(context)
          : null,
      body: isLoad
          ? Obx(() => Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ), //top level space
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: homeScreenController.categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // ignore: no_leading_underscores_for_local_identifiers
                        void _onLoading() {
                          setState(() {
                            _selectedIndex = index;
                          });
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
                          Future.delayed(const Duration(seconds: 3), () async {
                            Navigator.pop(context); //pop dialog

                            await businessController
                                .getAllSubCategoriesServices(
                              widget.buisnessId!,
                              homeScreenController.categories[index].id,
                            );
                          });
                        }

                        return InkWell(
                          onTap: _onLoading,
                          child: categoriesSlider(context, index),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  listOfServices(context),
                ],
              ))
          : Center(
              child: CircularProgressIndicator(
                color: Colr.primary,
              ),
            ),
    );
  }

  SizedBox noOfServices(BuildContext context) {
    return SizedBox(
      height: 90,
      child: PhysicalModel(
        color: Colors.grey.shade100,
        elevation: 25,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0),
            ),
            // border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, // shadow color
                  blurRadius: 5, // shadow radius
                  // offset: Offset(1, 5), // shadow offset
                  spreadRadius:
                      0.1, // The amount the box should be inflated prior to applying the blur
                  blurStyle: BlurStyle.outer // set blur style
                  ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffBFC6D1),
                            borderRadius: BorderRadius.circular(5)),
                        height: Get.height * .005,
                        width: Get.width * .1,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: AppButtons(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.45,
                      backgroundColor: Colr.primary,
                      textColor: Colors.white,
                      text: "Book Appointment".tr,
                      decoration: BoxDecoration(
                        color: Colr.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      onPressed: () {
                        if (profileController.userInOrOut.value) {
                          bookAppointmentController
                              .getCardDetails()
                              .then((value) {
                            if (value["IsActive"] ?? false) {
                              Get.to(() => SelectStaffAndTimingScreen(
                                    businessId: widget.buisnessId!,
                                  ));
                            } else {
                              Get.to(() => const YaadPayScreen());
                            }
                          });
                        } else {
                          Fluttertoast.showToast(msg: "Please login first".tr);
                          Get.to(HomeScreen(
                              selectedIndex: 0,
                              businessId: widget.buisnessId!));
                        }
                      },
                    ),
                    trailing: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.32,
                      child: Column(
                        children: [
                          CommenTextWidget(
                              s: '${getTotalPrice()} ${'NIS'.tr}',
                              clr: Colors.black),
                          CommenTextWidget(
                              s: '${'Services X'.tr} ${getSum()}',
                              clr: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Obx listOfServices(BuildContext context) {
    return Obx(() => Expanded(
          child: SingleChildScrollView(
            child: businessController.subCategoryList.isNotEmpty
                ? Column(
                    children: List.generate(
                        businessController.subCategoryList.length, ((index) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 7),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: CommenTextWidget(
                            s: localizationController.isHebrew.value
                                ? businessController
                                    .subCategoryList[index].subCategoryNameH
                                : capitalize(businessController
                                    .subCategoryList[index].subCategoryName),
                            fw: FontWeight.w700,
                            size: 18,
                          ),
                        ),
                        subtitle: Column(
                            children: List.generate(
                                businessController.subCategoryList[index]
                                    .serviceList.length, (i) {
                          var e = businessController
                              .subCategoryList[index].serviceList[i];

                          var isExists = false;

                          isExists = bookAppointmentController.addedServices
                              .map((item) => item.services.serviceId)
                              .contains(e.serviceId);

                          if (isExists) {}
                          return Column(
                            children: [
                              Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  // ignore: sort_child_properties_last
                                  children: List.generate(
                                      businessController
                                          .subCategoryList[index]
                                          .serviceList[i]
                                          .subServiceList
                                          .length, ((v) {
                                    var e2 = businessController
                                        .subCategoryList[index]
                                        .serviceList[i]
                                        .subServiceList[v];

                                    var isSubServiceExists = false;

                                    isSubServiceExists =
                                        bookAppointmentController
                                            .addedSubServices
                                            .map((item) =>
                                                item.subService.subServiceId)
                                            .contains(e2.subServiceId);

                                    if (isSubServiceExists) {}

                                    return Container(
                                      color: Colors.grey.withOpacity(0.1),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 7),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: CommenTextWidget(
                                                s: businessController
                                                    .subCategoryList[index]
                                                    .serviceList[i]
                                                    .subServiceList[v]
                                                    .subServiceName,
                                                fw: FontWeight.w400,
                                                size: 15,
                                                clr: Colors.black,
                                              ),
                                            ),
                                            subtitle: businessController
                                                            .subCategoryList[
                                                                index]
                                                            .serviceList[i]
                                                            .subServiceList[v]
                                                            .duration !=
                                                        null ||
                                                    businessController
                                                            .subCategoryList[
                                                                index]
                                                            .serviceList[i]
                                                            .subServiceList[v]
                                                            .duration !=
                                                        ''
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 13.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/timer.png'))),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3.0),
                                                          child:
                                                              CommenTextWidget(
                                                            s: localizationController
                                                                    .isHebrew
                                                                    .value
                                                                ? businessController
                                                                    .subCategoryList[
                                                                        index]
                                                                    .serviceList[
                                                                        i]
                                                                    .subServiceList[
                                                                        v]
                                                                    .durationH!
                                                                : businessController
                                                                    .subCategoryList[
                                                                        index]
                                                                    .serviceList[
                                                                        i]
                                                                    .subServiceList[
                                                                        v]
                                                                    .duration!,
                                                            clr: Colr
                                                                .secondaryGrey,
                                                            size: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : null,
                                            trailing: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CommenTextWidget(
                                                    s: '${'NIS'.tr}${businessController.subCategoryList[index].serviceList[i].subServiceList[v].price}',
                                                    clr: Colors.black,
                                                    fw: FontWeight.w400,
                                                    size: 15,
                                                  ),
                                                  AppButtons(
                                                    onPressed: () {
                                                      togglesubServiceSelectedListTile(
                                                          e2,
                                                          businessController
                                                                  .subCategoryList[
                                                              index],
                                                          businessController
                                                              .subCategoryList[
                                                                  index]
                                                              .serviceList[i]);
                                                    },
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    textColor:
                                                        isSubServiceExists
                                                            ? Colors.grey
                                                            : Colr.primaryLight,
                                                    text: isSubServiceExists
                                                        ? "Selected".tr
                                                        : "Choose".tr,
                                                    fontSize: 12,
                                                    ////subservice
                                                    decoration: BoxDecoration(
                                                        color: isSubServiceExists
                                                            ? Colr.primaryLight
                                                            : Colr.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        border: Border.all(
                                                            color: isSubServiceExists
                                                                ? Colors.grey
                                                                : Colr
                                                                    .primary)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          v ==
                                                  businessController
                                                          .subCategoryList[
                                                              index]
                                                          .serviceList[i]
                                                          .subServiceList
                                                          .length -
                                                      1
                                              ? const SizedBox()
                                              : const Divider()
                                        ],
                                      ),
                                    );
                                  })),

                                  title: CommenTextWidget(
                                      s: localizationController.isHebrew.value
                                          ? businessController
                                              .subCategoryList[index]
                                              .serviceList[i]
                                              .serviceNameH
                                          : businessController
                                              .subCategoryList[index]
                                              .serviceList[i]
                                              .serviceName,
                                      sw: true,
                                      mxL: 2,
                                      fw: FontWeight.w400,
                                      clr: Colors.black),
                                  subtitle: businessController
                                              .subCategoryList[index]
                                              .serviceList[i]
                                              .duration !=
                                          null
                                      ? Row(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: 15,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/timer.png'))),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3.0),
                                              child: CommenTextWidget(
                                                s: localizationController
                                                        .isHebrew.value
                                                    ? '${businessController.subCategoryList[index].serviceList[i].durationH}'
                                                    : '${businessController.subCategoryList[index].serviceList[i].duration}',
                                                clr: Colr.secondaryGrey,
                                                size: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                  trailing: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: businessController
                                            .subCategoryList[index]
                                            .serviceList[i]
                                            .subServiceList
                                            .isEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: CommenTextWidget(
                                                  s: '${'NIS'.tr}${businessController.subCategoryList[index].serviceList[i].price}',
                                                  clr: Colors.black,
                                                  fw: FontWeight.w400,
                                                  size: 15,
                                                ),
                                              ),
                                              AppButtons(
                                                onPressed: () {
                                                  toggleSelectedListTile(
                                                      e,
                                                      businessController
                                                              .subCategoryList[
                                                          index]);
                                                },
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                textColor: isExists
                                                    ? Colors.grey
                                                    : Colr.primaryLight,
                                                text: isExists
                                                    ? "Selected".tr
                                                    : "Choose".tr,
                                                fontSize: 12,
                                                decoration: BoxDecoration(
                                                    color: isExists
                                                        ? Colr.primaryLight
                                                        : Colr.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    border: Border.all(
                                                        color: isExists
                                                            ? Colors.grey
                                                            : Colr.primary)),
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: const [
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                                size: 26,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              i ==
                                      businessController
                                              .subCategoryList[index]
                                              .serviceList[i]
                                              .subServiceList
                                              .length -
                                          1
                                  ? const SizedBox()
                                  : const Divider()
                            ],
                          );
                        })),
                      );
                    })),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          size: 15,
                          fs: FontStyle.normal,
                          fw: FontWeight.bold,
                          clr: Colr.primary,
                        ),
                      )
                    ],
                  ),
          ),
        ));
  }

  Column categoriesSlider(BuildContext context, int index) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          child: Material(
              shape:
                  const CircleBorder(side: BorderSide.none, eccentricity: 0.1),
              elevation: 1,
              child: CircleAvatar(
                radius: _selectedIndex == index ? 33 : 42,
                backgroundColor:
                    _selectedIndex == index ? Colr.primary : Colors.transparent,
                backgroundImage: AssetImage(
                  _selectedIndex == index
                      ? images.categoryImages[index]
                      : images.categoryLightImages[index],
                ),
              )),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: CommenTextWidget(
            s: localizationController.isHebrew.value
                ? homeScreenController.categories[index].categoryNameH
                : homeScreenController.categories[index].name.toCapitalCase(),
            align: TextAlign.center,
            ts: const TextStyle(color: Colors.black, fontSize: 11),
          ),
        ),
      ],
    );
  }

  getTotalPrice() {
    num totalPrice = 0.0;
    for (var element in bookAppointmentController.addedServices) {
      totalPrice = totalPrice + element.services.price;
    }
    for (var element in bookAppointmentController.addedSubServices) {
      totalPrice = totalPrice + element.subService.price;
    }

    return totalPrice;
  }

  getSum() {
    return bookAppointmentController.addedServices.length +
        bookAppointmentController.addedSubServices.length;
  }
}

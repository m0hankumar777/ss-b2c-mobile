// ignore_for_file: unnecessary_null_comparison

import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/controller/punchcard_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:intl/intl.dart';
import 'package:B2C/controller/login_controller.dart' as loginauth;

// ignore: must_be_immutable
class PunchCardScreen extends StatefulWidget {
  int? buisnessId;

  PunchCardScreen({super.key, this.buisnessId});

  @override
  State<PunchCardScreen> createState() => _PunchCardScreenState();
}

class _PunchCardScreenState extends State<PunchCardScreen> {
  final punchCardController = Get.put(PunchCardController());
  final localizationController = Get.put(LocalizationController());
  final customerController = Get.put(CustomerController());

  bool isLogin = loginauth.getLoginStatus();

  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    if (isLogin) {
      customerController.getUserInformation();
    }

    await punchCardController.getAllPunchCards(
      customerController.custInfo.value.id!,
    );

    setState(() {
      isLoad = true;
    });
  }

  noImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 150,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/no_reviews.png',
            height: 100,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CommenTextWidget(
          clr: Colr.primary,
          size: 18,
          s: 'No Punch Cards Available'.tr,
          fw: FontWeight.bold,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommenTextWidget(
          s: 'Punch Card'.tr,
          clr: Colors.black,
          size: 16,
          fw: FontWeight.bold,
        ),
        centerTitle: true,
        leading: localizationController.isHebrew.value
            ? null
            : IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                  size: 18,
                )),
        actions: [
          localizationController.isHebrew.value
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                    size: 18,
                  ))
              : Container()
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // 1
      ),
      body: isLoad
          ? Obx(() => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: punchCardController.punchCardList.isNotEmpty
                            ? Column(
                                children: List.generate(
                                    punchCardController.punchCardList.length,
                                    ((index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0,
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        child: Theme(
                                          data: ThemeData().copyWith(
                                              dividerColor: Colors.transparent),
                                              child: ExpansionTile(
                                              leading: Container(
                                                width: Get.width * 0.17,
                                                height: Get.width * 0.19,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: punchCardController
                                                                .punchCardList[
                                                                    index]
                                                                .imageUrl !=
                                                            null
                                                        ? DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                punchCardController
                                                                    .punchCardList[
                                                                        index]
                                                                    .imageUrl))
                                                        : const DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage("assets/images/glamz-logo.png"))),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CommenTextWidget(
                                                      s: punchCardController
                                                          .punchCardList[index]
                                                          .name,
                                                      size: 15,
                                                      clr: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: SizedBox(
                                                width: Get.width * 0.6,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    addressField(
                                                        context, index),
                                                  ],
                                                ),
                                              ),
                                              trailing: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    CommenTextWidget(
                                                      s: punchCardController
                                                          .punchCardList[index]
                                                          .mobileNo
                                                          .toString(),
                                                      clr: Colors.black,
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: CommenTextWidget(
                                                        s: '${"Punch:".tr} ${punchCardController.punchCardList[index].totalPunchCardSum}',
                                                        size: 13,
                                                        clr: Colr.primary,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              children: List.generate(
                                                  punchCardController
                                                      .punchCardList[index]
                                                      .punchCards
                                                      .length, ((v) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                        title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CommenTextWidget(
                                                              s: localizationController
                                                                      .isHebrew
                                                                      .value
                                                                  ? punchCardController
                                                                      .punchCardList[
                                                                          index]
                                                                      .punchCards[
                                                                          v]
                                                                      .serviceNameH
                                                                  : punchCardController
                                                                      .punchCardList[
                                                                          index]
                                                                      .punchCards[
                                                                          v]
                                                                      .serviceName,
                                                              fw: FontWeight
                                                                  .w400,
                                                              size: 14,
                                                            ),
                                                            Row(
                                                              children: [
                                                                CommenTextWidget(
                                                                  s: "Available Punch:"
                                                                      .tr,
                                                                  size: 13,
                                                                  clr: Colr
                                                                      .secondaryGrey3,
                                                                ),
                                                                CommenTextWidget(
                                                                  s: ' ${punchCardController.punchCardList[index].punchCards[v].totalPunchCardDone.toString()}/${punchCardController.punchCardList[index].punchCards[v].totalPunchCard.toString()} ',
                                                                  fw: FontWeight
                                                                      .w400,
                                                                  size: 13,
                                                                  clr: Colors
                                                                      .black,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        subtitle: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5.0,horizontal: 2),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CommenTextWidget(
                                                                    s: "Expiry Date:"
                                                                        .tr,
                                                                    size: 13,
                                                                    clr: Colr
                                                                        .secondaryGrey3,
                                                                  ),
                                                                  CommenTextWidget(
                                                                    s: ' ${DateFormat('dd-MM-yyyy').format(punchCardController.punchCardList[index].punchCards[v].expiryDate)}',
                                                                    fw: FontWeight
                                                                        .w400,
                                                                    size: 13,
                                                                    clr: Colors
                                                                        .black,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  CommenTextWidget(
                                                                    s: "Price"
                                                                        .tr,
                                                                    size: 13,
                                                                    clr: Colr
                                                                        .secondaryGrey3,
                                                                  ),
                                                                  CommenTextWidget(
                                                                    // ignore: prefer_interpolation_to_compose_strings
                                                                    s: " " +
                                                                        'NIS'
                                                                            .tr +
                                                                        ' ' +
                                                                        punchCardController
                                                                            .punchCardList[index]
                                                                            .punchCards[v]
                                                                            .price
                                                                            .toString(),
                                                                    fw: FontWeight
                                                                        .w400,
                                                                    size: 13,
                                                                    clr: Colors
                                                                        .black,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                    index ==
                                                            punchCardController
                                                                    .punchCardList[
                                                                        index]
                                                                    .punchCards
                                                                    .length -
                                                                1
                                                        ? const SizedBox()
                                                        : const Divider()
                                                  ],
                                                );
                                              }))),
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                              )
                            : noImage(),
                      ),
                    ),
                  ],
                ),
              ))
          : Center(
              child: CircularProgressIndicator(
                color: Colr.primary,
              ),
            ),
    );
  }

  punchDetailList(String title, String value, {FontWeight? fw, Color? clr}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 35,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Container(
                alignment: localizationController.isHebrew.value
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  alignment: localizationController.isHebrew.value
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: fw ?? FontWeight.w400,
                      color: clr ?? Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row addressField(BuildContext context, int pv) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            punchCardController.punchCardList[pv].address,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w300),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

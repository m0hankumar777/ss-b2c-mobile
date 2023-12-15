import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/utility/ui_helper.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/controller/login_controller.dart' as loginauth;
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../controller/localization_controller.dart';
import '../../../controller/notification_controller.dart';
import '../../../utility/themes_b2c.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final localizationController = Get.put(LocalizationController());
  final notificationController = Get.put(NotificationController());
  final customerController = Get.put(CustomerController());
  bool isLoad = true;
  String checkvalue = '';
  bool textBtnswitchState = false;
  bool textBtnswitchState1 = false;
  bool isEnglish = false;
  bool isHebrew = false;
  String lang = '';
  bool login = false;

  @override
  void initState() {
    super.initState();
    fetchAPI();

    setState(() {
      lang = localizationController.isHebrew.value ? 'עברית' : 'English';
      localizationController.isHebrew.value
          ? isHebrew = true
          : isEnglish = true;
    });
  }

  Future<void> fetchAPI() async {
    customerController.getUserInformation();
    if (customerController.custInfo.value.id != null) {
      await notificationController
          .getNotificatonCustomerByID(customerController.custInfo.value.id!);
    }

    setState(() {
      textBtnswitchState = notificationController
                  .smsnotification.value.notificationEnabled ==
              null
          ? false
          : notificationController.smsnotification.value.notificationEnabled!;
      textBtnswitchState1 =
          notificationController.smsnotification.value.pushNotificationforMob ==
                  null
              ? false
              : notificationController
                  .smsnotification.value.pushNotificationforMob!;
    });
    isLoad = false;
    // print(profileController.customerDetails.value.customerProfileId.toString() +
    //  'customerId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottomOpacity: 0,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: localizationController.isHebrew.value ? null : iconButton(),
          actions: [
            localizationController.isHebrew.value ? iconButton() : Container(),
          ],
          centerTitle: true,
          title: CommenTextWidget(
            s: "Settings".tr,
            fw: FontWeight.bold,
            size: 18,
            clr: Colors.black,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: isLoad
                ? Padding(
                    padding: EdgeInsets.only(top: Get.height / 2.2),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colr.primary,
                      ),
                    ),
                  )
                : Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: Get.height * .3,
                                width: double.infinity,
                                child: StatefulBuilder(
                                  builder: (context, set) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: CommenTextWidget(
                                            s: 'Language'.tr,
                                            size: 18,
                                            fs: FontStyle.normal,
                                            fw: FontWeight.bold,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            setState(() {
                                              isEnglish = true;
                                              isHebrew = false;
                                              lang = 'ENGLISH';
                                            });
                                            Hive.box("language").clear();
                                            Hive.box("language").add("English");
                                            localizationController.changeLocale(
                                                const Locale('en', 'US'));
                                            Get.back();
                                          },
                                          leading: const Text(
                                            '🇺🇸',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          title: CommenTextWidget(
                                            s: 'ENGLISH'.tr,
                                            size: 18,
                                            fs: FontStyle.normal,
                                            fw: FontWeight.bold,
                                          ),
                                          trailing: Icon(
                                            Icons.done,
                                            color: isEnglish
                                                ? Colr.primary
                                                : Colors.white,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            setState(() {
                                              isHebrew = true;
                                              isEnglish = false;
                                              lang = 'עִברִית';
                                            });
                                            Hive.box("language").clear();
                                            Hive.box("language").add("Hebrew");
                                            localizationController.changeLocale(
                                                const Locale('he', 'IL'));
                                            Get.back();
                                          },
                                          leading: const Text('🇮🇱',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          title: CommenTextWidget(
                                            s: 'עִברִית',
                                            size: 18,
                                            fs: FontStyle.normal,
                                            fw: FontWeight.bold,
                                          ),
                                          trailing: Icon(
                                            Icons.done,
                                            color: isHebrew
                                                ? Colr.primary
                                                : Colors.white,
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommenTextWidget(
                                        s: lang,
                                        size: 18,
                                        fs: FontStyle.normal,
                                        fw: FontWeight.bold,
                                      ),
                                      CommenTextWidget(
                                        s: 'Language'.tr,
                                        size: 18,
                                        fs: FontStyle.normal,
                                        fw: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    loginIs() ? receiveSms() : Container(),
                    loginIs() ? receiveNotification() : Container(),
                  ]),
          ),
        ));
  }

  receiveNotification() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: textBtnswitchState1
                    ? () {
                        setState(() {
                          textBtnswitchState1 = true;
                        });
                      }
                    : null,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.black;
                      } else {
                        return Colors.black;
                      }
                    },
                  ),
                ),
                child: CommenTextWidget(
                  s: 'Receiving notifications'.tr,
                  size: 18,
                  fw: FontWeight.w400,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Transform.scale(
                       transformHitTests: false,
                          scale: 0.9,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: CupertinoSwitch(
                           activeColor: Colr.primary,
                          value: textBtnswitchState1,
                          onChanged: (newState) {
                            setState(() {
                              textBtnswitchState1 = newState;
                            });
                            notificationController
                                .checkPushNotification(
                                    customerController.custInfo.value.id!,
                                    textBtnswitchState1,
                                    DateTime.now().toIso8601String())
                                .then((value) {
                              if (value == 200) {
                                commonToast(
                                    'Push Notification Status updated'.tr);
                              } else {
                                commonToast('Not updated'.tr);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: CommenTextWidget(
            s: "You can stop receiving burst notifications. Please note: if you turn off both text messages and burst notifications, we will not be able to inform you about confirmation/update/cancellation of appointments."
                .tr,
            size: 14,
            fw: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  receiveSms() {
    return Column(
      children: [
        const Divider(
          color: Color.fromARGB(255, 197, 197, 197),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: textBtnswitchState
                    ? () {
                        setState(() {
                          textBtnswitchState = true;
                        });
                      }
                    : null,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.black;
                      } else {
                        return Colors.black;
                      }
                    },
                  ),
                ),
                child: CommenTextWidget(
                  s: 'Receiving SMS messages'.tr,
                  size: 18,
                  fw: FontWeight.w400,
                ),
              ),
              Column(
                children: [
                  Transform.scale(
                       transformHitTests: false,
                          scale: 0.9,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: CupertinoSwitch(
                        activeColor: Colr.primary,
                        value: textBtnswitchState,
                        onChanged: (newState) {
                          setState(() {
                            textBtnswitchState = newState;
                          });
                          notificationController
                              .checkNotification(
                                  customerController.custInfo.value.id!,
                                  textBtnswitchState)
                              .then((value) {
                            if (value == 200) {
                              commonToast('SMS Notification Status updated'.tr);
                            } else {
                              commonToast('Not updated'.tr);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: CommenTextWidget(
            s: "You can stop receiving text messages at any time. It's best to turn off cold SMS if you have the Glamz app so you don't miss important notifications."
                .tr,
            size: 14,
            fw: FontWeight.w400,
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 197, 197, 197),
        ),
      ],
    );
  }

  Padding iconButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            localizationController.isHebrew.value
                ? Icons.arrow_forward_ios_outlined
                : Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 18,
          )),
    );
  }

  loginIs() {
    login = loginauth.getLoginStatus();
    return login;
  }
}

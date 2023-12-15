import 'package:B2C/controller/appointmentlist_controller.dart';
import 'package:B2C/controller/book_appointment_controller.dart';
import 'package:B2C/controller/profile_controller.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:B2C/view/screens/ProfileScreens/personal_information_screen.dart';
import 'package:B2C/view/screens/ProfileScreens/punch_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../model/Authentication/customer_model.dart';
import '../../../utility/themes_b2c.dart';
import '../Authentication/login_screen.dart';
import 'credit_card_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  int? businessId;
  ProfileScreen({this.businessId, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.put(ProfileController());
  final bookAppointmentController = Get.put(BookAppointmentController());
  final appList = Get.put(AppointmentListController());
  @override
  void initState() {
    super.initState();

    profileController.introScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommenTextWidget(
          s: 'Profile'.tr,
          clr: Colors.black,
          size: 18,
          fw: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => profileController.userInOrOut.value
            ? Column(children: [
                ListTile(
                    onTap: () {
                      Get.to(const PersonalInformation());
                    },
                    leading: const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.black,
                    ),
                    title: CommenTextWidget(
                      s: "Personal Information".tr,
                      size: 18,
                    ),
                    trailing: const Icon(
                      (Icons.arrow_forward_ios_rounded),
                      size: 15,
                    )),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: Colors.black,
                  ),
                  title: CommenTextWidget(
                    s: "Credit Card".tr,
                    size: 18,
                  ),
                  trailing: const Icon(
                    (Icons.arrow_forward_ios_rounded),
                    size: 15,
                  ),
                  onTap: () {
                    Get.to(() =>
                        const CreditCard()); // bookAppointmentController.getCardDetails().then((value) {
                    //   if (value["IsActive"] ?? false) {
                    //     Fluttertoast.showToast(
                    //         msg: "Card details already added");
                    //   } else {
                    //     Get.to(() => const YaadPayScreen());
                    //   }
                    // });
                  },
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.wallet,
                    color: Colors.black,
                  ),
                  title: CommenTextWidget(
                    s: "Punch Card".tr,
                    size: 18,
                  ),
                  trailing: const Icon(
                    (Icons.arrow_forward_ios_rounded),
                    size: 15,
                  ),
                  onTap: () {
                    Get.to(PunchCardScreen());
                  },
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                ListTile(
                  leading: const Image(
                    image: AssetImage("assets/images/exit.png"),
                    height: 25,
                    width: 25,
                  ),
                  title: CommenTextWidget(
                    s: "Logout".tr,
                    size: 18,
                    clr: Colr.primary,
                  ),
                  trailing: const Icon(
                    (Icons.arrow_forward_ios_rounded),
                    size: 15,
                  ),
                  onTap: () async {
                    Get.defaultDialog(
                      title: 'Logout'.tr,
                      content: Column(
                        children: [
                          CommenTextWidget(
                              s: 'Are you sure you want to logout?'.tr),
                        ],
                      ),
                      actions: <Widget>[
                        InkWell(
                          onTap: () async {
                            await Hive.box("login").clear();
                            await Hive.box<Customer>("customer").clear();
                            setState(() {
                              profileController.userInOrOut.value = false;
                              profileController.isLoad.value = true;
                            });
                            appList.appointmentListCount.value = '0';
                            Get.offAll(HomeScreen(
                              selectedIndex: 0,
                              isQues: true,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colr.primary,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CommenTextWidget(
                                s: 'Okay'.tr,
                                clr: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colr.primary,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CommenTextWidget(
                                s: 'Cancel'.tr,
                                clr: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colr.primary,
                  ),
                  title: CommenTextWidget(
                    s: "Delete Account".tr,
                    size: 18,
                    clr: Colr.primary,
                  ),
                  trailing: const Icon(
                    (Icons.arrow_forward_ios_rounded),
                    size: 15,
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      title: 'Delete Account'.tr,
                      content: Column(
                        children: [
                          CommenTextWidget(
                              s: 'Are you sure you want to delete your account from Glamz?'
                                  .tr),
                        ],
                      ),
                      actions: <Widget>[
                        InkWell(
                          onTap: () {
                            deleteClient();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colr.primary,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CommenTextWidget(
                                s: 'Okay'.tr,
                                clr: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colr.primary,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CommenTextWidget(
                                s: 'Cancel'.tr,
                                clr: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ])
            : checkUser(),
      ),
    );
  }

  checkUser() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          isLoginCLicked: true,
                          businessId: widget.businessId,
                        )),
              );
            },
            leading: const Icon(
              Icons.login_sharp,
              color: Colors.black,
            ),
            title: CommenTextWidget(
              s: "Login".tr,
              size: 18,
            ),
            trailing: const Icon(
              (Icons.arrow_forward_ios_rounded),
              size: 15,
            )),
        Container(
          color: Colors.grey[200],
          height: 1,
          width: Get.width * .91,
        ),
        ListTile(
          leading: const Icon(
            Icons.app_registration_sharp,
            color: Colors.black,
          ),
          title: CommenTextWidget(
            s: "Register".tr,
            size: 18,
          ),
          trailing: const Icon(
            (Icons.arrow_forward_ios_rounded),
            size: 15,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen(
                        isLoginCLicked: false,
                      )),
            );
          },
        ),
      ]),
    );
  }

  Future<void> deleteClient() async {
    await profileController.deleteClientApi().then((value) async {
      if (value == "Customer Deleted") {
        Fluttertoast.showToast(msg: "Customer deleted successfully".tr);
        await Hive.box("login").clear();
        await Hive.box<Customer>("customer").clear();
        setState(() {
          profileController.userInOrOut.value = false;
          profileController.isLoad.value = true;
        });
        Get.offAll(HomeScreen(
          selectedIndex: 0,
          isQues: true,
        ));
      } else if (value ==
          "Customer cannot be deleted since there are appointments") {
        Fluttertoast.showToast(
            msg: "Customer cannot be deleted since there are appointments".tr);
        Get.back();
      } else {
        Fluttertoast.showToast(msg: "Can't be deleted".tr);
        Get.back();
      }
    });
  }
}

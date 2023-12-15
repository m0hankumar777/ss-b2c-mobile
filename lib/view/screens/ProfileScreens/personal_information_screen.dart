import 'package:B2C/controller/login_controller.dart';
import 'package:B2C/controller/profile_controller.dart';
import 'package:B2C/main.dart';
import 'package:B2C/services/profileScreen/profile_service.dart';
import 'package:B2C/utility/ui_helper.dart';
import 'package:B2C/view/screens/ProfileScreens/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/customer_controller.dart';
import '../../../utility/enum.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  final profileController = Get.put(ProfileController());
  final loginController = Get.put(LoginController());
  final customerController = Get.put(CustomerController());
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  // String? hebrewGender;
  // String? englishGender;

  @override
  void initState() {
    super.initState();
    profileController.isLoad.value = true;
    setState(() {});
    fetchData();
  }

  fetchData() async {
    if (mounted) {
      await customerController.getUserInformation();
      await profileController.getProfileInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottomOpacity: 0,
          elevation: 0,
          backgroundColor: Colors.white,
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
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 18,
                    ))
                : Container()
          ],
          centerTitle: true,
          title: CommenTextWidget(
            s: "Personal Information".tr,
            fw: FontWeight.bold,
            size: 23,
            clr: Colors.black,
          ),
        ),
        body: Obx((() => profileController.isLoad.value
            ? const Center(
                child: CircularProgressIndicator(
                color: Color.fromARGB(255, 188, 49, 39),
              ))
            : Column(children: [
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: Get.height * .2,
                          width: double.infinity,
                          child: StatefulBuilder(
                            builder: (context, set) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RadioListTile(
                                    activeColor: const Color(0xffAE1133),
                                    value: 'Male'.tr,
                                    groupValue: localizationController
                                            .isHebrew.value
                                        ? profileController.hebrewGender.value
                                        : profileController.englishGender.value,
                                    onChanged: (value) {
                                      set(
                                        () {
                                          profileController.profileInformation
                                              .value.gender = value;
                                          localizationController.isHebrew.value
                                              ? profileController
                                                  .hebrewGender.value = value!
                                              : profileController
                                                  .englishGender.value = value!;
                                          Get.back();
                                        },
                                      );
                                      setState(() {
                                        profileController.profileInformation
                                            .value.gender = value;
                                        localizationController.isHebrew.value
                                            ? profileController
                                                .hebrewGender.value
                                            : profileController
                                                .englishGender.value;
                                      });
                                      ProfileServices().updateGender({
                                        "profileId": customerController
                                            .custInfo.value.id,
                                        "gender": "male"
                                      }).then((value) {
                                        if (value == 200) {
                                          commonToast(
                                              "Updated!! Your changes has been updated successfully"
                                                  .tr);
                                        } else {
                                          commonToast("Not Updated".tr);
                                        }
                                      });
                                    },
                                    title: CommenTextWidget(
                                      s: "Male".tr,
                                      size: 18,
                                    ),
                                  ),
                                  RadioListTile(
                                    activeColor: const Color(0xffAE1133),
                                    value: 'Female'.tr,
                                    groupValue: localizationController
                                            .isHebrew.value
                                        ? profileController.hebrewGender.value
                                        : profileController.englishGender.value,
                                    onChanged: (value) {
                                      set(
                                        () {
                                          profileController.profileInformation
                                              .value.gender = value;
                                          localizationController.isHebrew.value
                                              ? profileController
                                                  .hebrewGender.value = value!
                                              : profileController
                                                  .englishGender.value = value!;
                                          Get.back();
                                        },
                                      );
                                      setState(() {
                                        profileController.profileInformation
                                            .value.gender = value;
                                        localizationController.isHebrew.value
                                            ? profileController
                                                .hebrewGender.value
                                            : profileController
                                                .englishGender.value;
                                      });
                                      ProfileServices().updateGender({
                                        "profileId": customerController
                                            .custInfo.value.id,
                                        "gender": "female"
                                      }).then((value) {
                                        if (value == 200) {
                                          commonToast(
                                              "Updated!! Your changes has been updated successfully"
                                                  .tr);
                                        } else {
                                          commonToast("Not Updated".tr);
                                        }
                                      });
                                    },
                                    title: CommenTextWidget(
                                      s: "Female".tr,
                                      size: 18,
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
                  leading: CommenTextWidget(
                    s: "Gender".tr,
                    size: 18,
                  ),
                  trailing: Text(
                    profileController.profileInformation.value.gender == null
                        ? ""
                        : localizationController.isHebrew.value
                            ? profileController.hebrewGender.value
                            : profileController.englishGender.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  onTap: () {
                    Get.to(ProfileEditScreen(
                      types: EditProfileInformation.EditFirstName,
                      content: profileController
                          .profileInformation.value.firstname
                          .toString(),
                    ));
                  },
                  leading: CommenTextWidget(
                    s: "First Name".tr,
                    size: 18,
                  ),
                  trailing: Text(
                    profileController.profileInformation.value.firstname == null
                        ? ""
                        : profileController.profileInformation.value.firstname
                            .toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => ProfileEditScreen(
                          types: EditProfileInformation.EditLastName,
                          content: profileController
                              .profileInformation.value.lastname
                              .toString(),
                        ));
                  },
                  leading: CommenTextWidget(
                    s: "Last Name".tr,
                    size: 18,
                  ),
                  trailing: Text(
                    profileController.profileInformation.value.lastname == null
                        ? ""
                        : profileController.profileInformation.value.lastname
                            .toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => ProfileEditScreen(
                          types: EditProfileInformation.EditMail,
                          content: profileController
                                  .profileInformation.value.profileEmail
                                  .toString()
                                  .contains("client@glamz.com")
                              ? ""
                              : profileController
                                  .profileInformation.value.profileEmail
                                  .toString(),
                        ));
                  },
                  leading: CommenTextWidget(
                    s: "Email".tr,
                    size: 18,
                  ),
                  trailing: Text(
                    profileController.profileInformation.value.profileEmail ==
                            null
                        ? ""
                        : profileController
                                .profileInformation.value.profileEmail
                                .toString()
                                .contains("client@glamz.com")
                            ? ""
                            : profileController
                                .profileInformation.value.profileEmail
                                .toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  height: 1,
                  width: Get.width * .91,
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => ProfileEditScreen(
                          types: EditProfileInformation.EditDob,
                          content: (profileController
                                      .profileInformation.value.dob!
                                      .toString() ==
                                  "0001-01-01 00:00:00.000")
                              ? ''
                              : changeDateFormat(profileController
                                      .profileInformation.value.dob!)
                                  .toString(),
                        ));
                  },
                  leading: CommenTextWidget(
                    s: "Date Of Birth".tr,
                    size: 18,
                  ),
                  trailing: Text(
                    profileController.profileInformation.value.dob!
                                .toString() ==
                            "0001-01-01 00:00:00.000"
                        ? ''
                        : changeDateFormat(
                                profileController.profileInformation.value.dob!)
                            .toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]))));
  }

  changeDateFormat(DateTime date) {
    String updateformattedDate = DateFormat('dd.MM.yyyy').format(date);
    return updateformattedDate;
  }
}

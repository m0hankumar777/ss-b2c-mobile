import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/services/profileScreen/profile_service.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/profile_controller.dart';
import '../../../utility/enum.dart';
import '../../../utility/ui_helper.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

// ignore: must_be_immutable
class ProfileEditScreen extends StatefulWidget {
  String content;
  EditProfileInformation types;
  // ignore: use_key_in_widget_constructors
  ProfileEditScreen({required this.types, required this.content});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController multiCont = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final profileController = Get.put(ProfileController());
  final customerController = Get.put(CustomerController());
  final localizationController = Get.put(LocalizationController());

  bool isDateChecker = false;
  bool isFormChecker = false;
  String? updateDate;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    multiCont.text = widget.types == EditProfileInformation.EditFirstName
        ? widget.content == "null"
            ? ""
            : widget.content
        : widget.types == EditProfileInformation.EditLastName
            ? widget.content == "null"
                ? ""
                : widget.content
            : widget.types == EditProfileInformation.EditMail
                ? widget.content == "null"
                    ? ""
                    : widget.content
                : '';
    dateinput.text = widget.types == EditProfileInformation.EditDob
        ? widget.content == "null"
            ? ""
            : widget.content
        : "";
  }

  fetchData() {
    customerController.getUserInformation();
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
            s: widget.types == EditProfileInformation.EditFirstName
                ? 'First Name'.tr
                : widget.types == EditProfileInformation.EditLastName
                    ? 'Last Name'.tr
                    : widget.types == EditProfileInformation.EditMail
                        ? 'email'.tr
                        : "Date Of Birth".tr,
            size: 23,
            fw: FontWeight.bold,
            clr: Colors.black,
          )),
      body: isUpdate
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 188, 49, 39)))
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  widget.types == EditProfileInformation.EditFirstName
                      ? EditField('First Name'.tr)
                      : widget.types == EditProfileInformation.EditLastName
                          ? EditField('Last Name'.tr)
                          : widget.types == EditProfileInformation.EditDob
                              ? DateField()
                              : EditField('email'.tr),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () {
                        if (multiCont.text.isNotEmpty ||
                            dateinput.text.isNotEmpty) {
                          // if (widget.content == multiCont.text ||
                          //     widget.content == dateinput.text) {
                          //   commonToast(
                          //       "Oops!! No Changes have been made !!!".tr);
                          //   Get.back();
                          // } else {
                          if (isDateChecker == false &&
                              isFormChecker == false) {
                            setState(() {
                              isUpdate = true;
                            });
                            widget.types == EditProfileInformation.EditDob
                                ? ProfileServices().updateD0B({
                                    "profileId":
                                        customerController.custInfo.value.id,
                                    "dob": "${updateDate}T00:00:00"
                                  }).then(
                                    (value) async {
                                      if (value == true) {
                                        commonToast(
                                            "Updated!! Your changes has been updated successfully"
                                                .tr);
                                        await profileController
                                            .getProfileInfo();
                                        setState(() {
                                          isUpdate = false;
                                        });
                                        Get.back();
                                      } else {
                                        commonToast("Not Updated".tr);
                                        setState(() {
                                          isUpdate = false;
                                        });
                                        Get.back();
                                      }
                                    },
                                  )
                                : widget.types ==
                                        EditProfileInformation.EditFirstName
                                    ? ProfileServices().updateFirstName({
                                        "profileId": customerController
                                            .custInfo.value.id,
                                        "firstName": multiCont.text
                                      }).then(
                                        (value) async {
                                          if (value == true) {
                                            commonToast(
                                                "Updated!! Your changes has been updated successfully"
                                                    .tr);
                                            await profileController
                                                .getProfileInfo();
                                            setState(() {
                                              isUpdate = false;
                                            });
                                            Get.back();
                                          } else {
                                            commonToast("Not Updated".tr);
                                            setState(() {
                                              isUpdate = false;
                                            });
                                            Get.back();
                                          }
                                        },
                                      )
                                    : widget.types ==
                                            EditProfileInformation.EditLastName
                                        ? ProfileServices().updateLastName({
                                            "profileId": customerController
                                                .custInfo.value.id,
                                            "lastName": multiCont.text
                                          }).then(
                                            (value) async {
                                              if (value == true) {
                                                commonToast(
                                                    "Updated!! Your changes has been updated successfully"
                                                        .tr);
                                                await profileController
                                                    .getProfileInfo();
                                                setState(() {
                                                  isUpdate = false;
                                                });
                                                Get.back();
                                              } else {
                                                commonToast("Not Updated".tr);
                                                setState(() {
                                                  isUpdate = false;
                                                });
                                                Get.back();
                                              }
                                            },
                                          )
                                        : ProfileServices().updateEmail({
                                            "profileId": customerController
                                                .custInfo.value.id,
                                            "profileEmail": multiCont.text
                                          }).then(
                                            (value) async {
                                              if (value == true) {
                                                commonToast(
                                                    "Updated!! Your changes has been updated successfully"
                                                        .tr);
                                                await profileController
                                                    .getProfileInfo();
                                                setState(() {
                                                  isUpdate = false;
                                                });
                                                Get.back();
                                              } else {
                                                commonToast("Not Updated".tr);
                                                setState(() {
                                                  isUpdate = false;
                                                });
                                                Get.back();
                                              }
                                            },
                                          );
                          }
                          // }
                        } else if (multiCont.text.isEmpty) {
                          if (widget.types == EditProfileInformation.EditMail) {
                            ProfileServices().updateEmail({
                              "profileId": customerController.custInfo.value.id,
                              "profileEmail": "client@glamz.com"
                            }).then(
                              (value) async {
                                if (value == true) {
                                  commonToast(
                                      "Updated!! Your changes has been updated successfully"
                                          .tr);
                                  await profileController.getProfileInfo();
                                  setState(() {
                                    isUpdate = false;
                                  });
                                  Get.back();
                                } else {
                                  commonToast("Not Updated".tr);
                                  setState(() {
                                    isUpdate = false;
                                  });
                                  Get.back();
                                }
                              },
                            );
                          }
                        } else {
                          commonToast("Please Enter the valid Data".tr);
                        }
                      },
                      child: Container(
                        height: Get.height * .07,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colr.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "update".tr,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
    );
  }

  // ignore: non_constant_identifier_names
  EditField(String hint) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: Get.height * .085,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: TextFormField(
              autofocus: false,
              cursorColor: Colors.black,
              autovalidateMode: AutovalidateMode.always,
              controller: multiCont,
              style: TextStyle(fontSize: Get.width / 25),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  labelStyle:
                      TextStyle(color: Colors.grey, fontSize: Get.width / 30),
                  labelText:
                      widget.types == EditProfileInformation.EditFirstName
                          ? "First Name".tr
                          : widget.types == EditProfileInformation.EditLastName
                              ? "Last Name".tr
                              : "Email".tr),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  isFormChecker = true;
                  if (widget.types == EditProfileInformation.EditFirstName) {
                    return "Enter First name".tr;
                  } else if (widget.types ==
                      EditProfileInformation.EditLastName) {
                    return "Enter Last name".tr;
                  }
                  // isFormChecker = true;
                  // return widget.types == EditProfileInformation.EditFirstName
                  //     ? "Enter First name".tr
                  //     : widget.types == EditProfileInformation.EditLastName
                  //         ? "Enter Last name".tr
                  //         : "Enter email".tr;
                } else {
                  isFormChecker = false;
                }
                if (value!.isNotEmpty) {
                  if (widget.types == EditProfileInformation.EditMail) {
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.com")
                        .hasMatch(value)) {
                      isFormChecker = true;
                      return 'Enter valid email'.tr;
                    } else {
                      isFormChecker = false;
                    }
                  }
                }
                if (widget.types == EditProfileInformation.EditFirstName ||
                    widget.types == EditProfileInformation.EditLastName) {
                  if (value.startsWith(' ')) {
                    isFormChecker = true;
                    return 'Enter valid Name'.tr;
                  } else {
                    isFormChecker = false;
                  }
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  DateField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: Get.height * .085,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: TextFormField(
              readOnly: true,
              // keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: dateinput,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Date Of Birth".tr,
                  labelStyle: const TextStyle(color: Colors.grey)),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                              primary: Color(0xff580176)),
                        ),
                        child: child!);
                  },
                );

                if (pickedDate != null) {
                  String updateFormattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                  setState(() {
                    dateinput.text = formattedDate;
                    updateDate = updateFormattedDate;
                    //"0001-01-01T00:00:00"
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  isDateChecker = true;
                  return "Enter Date".tr;
                } else if (!RegExp("^(0[1-9]|[12][0-9]|3[01])[- /.]")
                    .hasMatch(value)) {
                  isDateChecker = true;
                  return "Enter valid Date".tr;
                } else {
                  isDateChecker = false;
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }
}

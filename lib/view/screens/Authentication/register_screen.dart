import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/utility/widget_helper/common_elevated_button.dart';
import 'package:B2C/utility/widget_helper/custom_textform_field.dart';
import 'package:B2C/view/screens/Authentication/login_screen.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:B2C/services/Authentication/login_service.dart' as api;

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  String mobile;
  RegisterScreen({required this.mobile, super.key});
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final localizationController = Get.put(LocalizationController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fromDate = TextEditingController();
  String registered = '';
  String tabsIndex = 'Female';

  DateTime selectedDate = DateTime.now();

  bool isConditionAccepted = false;
  bool isNotifyAccepted = false;
  // ignore: prefer_typing_uninitialized_variables
  var pickedDate;
  bool isLoad = false;

  // ignore: prefer_void_to_null
  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Colr.primary),
            ),
            child: child!);
      },
    );
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        pickedDate = picked;
        fromDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
  }

  @override
  void initState() {
    super.initState();
  }

  var hint = TextStyle(
      fontSize: 15, color: Colr.secondaryGrey, fontWeight: FontWeight.w400);
  var style = TextStyle(color: Colr.secondaryGrey, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    final firstNameField = Container(
        decoration: const BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: CustomTextFormFieldWidget(
            autofocus: false,
            controller: firstNameController,
            keyboardtype: TextInputType.name,
            validatorFn: (value) {
              if (value!.isEmpty) {
                return "First name*".tr;
              } else if (value.trim().isEmpty) {
                return "First name*".tr;
              } else {
                return null;
              }
            },
            onSaved: (value) {
              firstNameController.text = value!;
            },
            style: style,
            textInputAction: TextInputAction.next,
            inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "First name*".tr,
              hintStyle: hint,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colr.secondaryGrey),
                  borderRadius: BorderRadius.circular(7)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colr.secondaryGrey),
                  borderRadius: BorderRadius.circular(7)),
            )));
    final lastNameField = Container(
        decoration: const BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: CustomTextFormFieldWidget(
            autofocus: false,
            controller: lastNameController,
            keyboardtype: TextInputType.name,
            validatorFn: (value) {
              if (value!.isEmpty) {
                return "Last Name*".tr;
              } else if (value.trim().isEmpty) {
                return "Last Name*".tr;
              } else {
                return null;
              }
            },
            onSaved: (value) {
              lastNameController.text = value!;
            },
            style: style,
            textInputAction: TextInputAction.next,
            inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Last Name*".tr,
              hintStyle: hint,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colr.secondaryGrey),
                  borderRadius: BorderRadius.circular(7)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colr.secondaryGrey),
                  borderRadius: BorderRadius.circular(7)),
            )));

    final emailField = CustomTextFormFieldWidget(
      autofocus: false,
      controller: emailController,
      keyboardtype: TextInputType.emailAddress,
      validatorFn: (value) {
        
        // if (value!.isEmpty) {
        //   return 'emailRequired'.tr;
        // }
        if(value!.isNotEmpty){
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.com").hasMatch(value)) {
          return 'Enter valid email'.tr;
        }
        if (!value.endsWith('.com')) {
          return 'Enter valid email'.tr;
        }
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: style,
      inputDecoration: InputDecoration(
        // prefixIcon: Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email".tr,
        hintStyle: hint,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colr.secondaryGrey),
            borderRadius: BorderRadius.circular(7)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colr.secondaryGrey),
            borderRadius: BorderRadius.circular(7)),
      ),
    );

    final dateOfBirthField = GestureDetector(
      onTap: () => _selectFromDate(context),
      child: AbsorbPointer(
        child: CustomTextFormFieldWidget(
          controller: fromDate,
          // initialValue: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
          inputDecoration: InputDecoration(
            // prefixIcon: Icon(Icons.mail),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Date Of Birth".tr,
            hintStyle: hint,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colr.secondaryGrey),
                borderRadius: BorderRadius.circular(7)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colr.secondaryGrey),
                borderRadius: BorderRadius.circular(7)),
          ),
          validatorFn: (string) {
            return null;
          },
        ),
      ),
    );
    getTermsAndCondition() {
      return Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colr.secondaryGrey, width: 2.3),
                  ),
                  width: 20,
                  height: 20,
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                      checkColor: Colr.primary,
                      activeColor: Colors.transparent,
                      value: isConditionAccepted,
                      tristate: false,
                      onChanged: (isChecked) {
                        setState(() {
                          isConditionAccepted = isChecked!;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  margin: const EdgeInsets.only(
                      left: 15, top: 15, right: 10, bottom: 15),
                  child: CommenTextWidget(
                    s: "I confirm and clarify that I have read and understood the terms of use of the application correctly and I agree to all the terms of use"
                        .tr,
                    sw: true,
                    mxL: 4,
                    ts: TextStyle(
                      color: Colr.secondaryGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    getAgreeNotify() {
      return Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colr.secondaryGrey, width: 2.3),
                  ),
                  width: 20,
                  height: 20,
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                      checkColor: Colr.primary,
                      activeColor: Colors.transparent,
                      value: isNotifyAccepted,
                      tristate: false,
                      onChanged: (isChecked) {
                        setState(() {
                          isNotifyAccepted = isChecked!;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  margin: const EdgeInsets.only(
                      left: 15, top: 15, right: 10, bottom: 15),
                  child: CommenTextWidget(
                      s: "I agree to receive notifications about the coupons and other publications"
                          .tr,
                      sw: true,
                      mxL: 4,
                      ts: TextStyle(
                        color: Colr.secondaryGrey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      )),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final continuedButton = GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AppButtons(
          textColor: isConditionAccepted && isNotifyAccepted
              ? Colr.primaryLight
              : Colr.primaryLight,
          backgroundColor: isConditionAccepted && isNotifyAccepted
              ? Colr.primary
              : const Color.fromRGBO(189, 189, 189, 1),
          borderColor: Colr.secondaryGrey,
          text: "Continued".tr,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          size: 50,
          height: 40,
          width: double.infinity,
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                isConditionAccepted &&
                isNotifyAccepted) {
              // setState(() {
              //   loading.onLoading(context);
              // });
              Map<String, dynamic> data = {
                "firstname": firstNameController.text,
                "lastname": lastNameController.text,
                // ignore: unnecessary_null_comparison
                "dob": fromDate.text != ''
                    ? "${(DateFormat('yyyy-MM-dd').format(pickedDate))}T00:00:00"
                    : "0001-01-01T00:00:00",
                // : "0001-01-01T07:22:54.635Z",
                "emailId": emailController.text,
                "phoneNumber": widget.mobile,
                "gender": tabsIndex,
              };
              registerClient(data);
            }
          },
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colr.primaryLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: localizationController.isHebrew.value ? null : iconButton(),
        actions: [
          localizationController.isHebrew.value ? iconButton() : Container()
        ],
        title: CommenTextWidget(
          s: "Personal Information".tr,
          size: 15,
          fw: FontWeight.w700,
          clr: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colr.primaryLight,
      ),
      body: isLoad
          ? Center(child: CircularProgressIndicator(color: Colr.primary))
          : DefaultTabController(
              length: 2,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: CommenTextWidget(
                              s: "Enter personal details".tr,
                              size: 18,
                              fw: FontWeight.w700,
                              clr: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 56,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.0),
                              child: TabBar(
                                onTap: (index) {
                                  setState(() {
                                    if (index == 0) {
                                      tabsIndex = 'Female';
                                    } else {
                                      tabsIndex = 'Male';
                                    }
                                    // tabsIndex = index.toString();
                                  });
                                  //your currently selected index
                                },
                                tabs: [
                                  CommenTextWidget(
                                    s: 'Female'.tr,
                                    size: 12,
                                    fw: FontWeight.w400,
                                  ),
                                  CommenTextWidget(
                                    s: 'Male'.tr,
                                    size: 12,
                                    fw: FontWeight.w400,
                                  ),
                                ],
                                indicator: ContainerTabIndicator(
                                    radius: const BorderRadius.all(
                                        Radius.circular(7.0)),
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colr.primary),
                                unselectedLabelColor: Colr.secondaryGrey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: firstNameField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: lastNameField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: emailField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: dateOfBirthField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: getTermsAndCondition(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: getAgreeNotify(),
                          ),

                          //  Expanded(
                          //    child: Align(
                          //      alignment: Alignment.bottomCenter,
                          //      child: ,
                          //    ),
                          //  )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                            width: double.infinity, child: continuedButton),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  IconButton iconButton() {
    return IconButton(
      icon: Icon(
        localizationController.isHebrew.value
            ? Icons.arrow_forward_ios_outlined
            : Icons.arrow_back_ios_new_outlined,
        size: 17,
        color: Colors.black,
      ),
      onPressed: () => Get.offAll(LoginScreen(isLoginCLicked: false)),
    );
  }

  Future<void> registerClient(Map<String, dynamic> data) async {
    SVProgressHUD.setForegroundColor(Colr.primary);
    SVProgressHUD.setRingThickness(5.5);
    SVProgressHUD.setCornerRadius(0.5);
    SVProgressHUD.setCornerRadius(0.5);
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom);
    SVProgressHUD.show();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      SVProgressHUD.dismiss();
    });
    api.LoginServices.register(data).then((value) async {
      // ignore: unrelated_type_equality_checks
      if (Value == '200') {
        // Fluttertoast.showToast(msg: "Registered Successfully".tr);
        // Get.snackbar('Registered'.tr, 'Registered Successfully'.tr,
        //     snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      selectedIndex: 2,
                    )));
      } else if (value == 'Email Id already exist') {
        Fluttertoast.showToast(msg: "Email-ID already exists!!!".tr);
      }else if (value == '500') {
        Fluttertoast.showToast(msg: "Internal Server Error!! Try Again later!!!".tr);
      }
    });
  }
}

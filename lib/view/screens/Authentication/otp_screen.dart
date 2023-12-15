import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/controller/login_controller.dart';
import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:B2C/view/screens/Authentication/register_screen.dart';
import 'package:B2C/services/Authentication/login_service.dart' as api;

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  String mobile;
  String logRegChk;
  String message;
  int? businessId;

  OtpScreen(
      {required this.mobile,
      required this.logRegChk,
      required this.message,
      this.businessId,
      super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final localizationController = Get.put(LocalizationController());
  final loginController = Get.put(LoginController());
  final TextEditingController confirmationcodeController =
      TextEditingController();
  final customerController = Get.put(CustomerController());

  String? logReg;
  String? tes;
  bool isValid = false;
  bool isBusinessIdExists = false;

  @override
  void dispose() {
    confirmationcodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.businessId != null) {
      isBusinessIdExists = true;
     }
    confirmationcodeController.text = '';
    confirmationcodeController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colr.primaryLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: localizationController.isHebrew.value ? null : iconButton(),
        actions: [
          localizationController.isHebrew.value ? iconButton() : Container()
        ],
        title: CommenTextWidget(
          s: "verification code".tr,
          size: 15,
          fw: FontWeight.w700,
          clr: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colr.primaryLight,
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommenTextWidget(
                      s: '${'To'.tr} ${widget.mobile} ${"We have sent you a mobile phone code.".tr}',
                      sw: true,
                      mxL: 3,
                      size: 15,
                      fw: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: CommenTextWidget(
                        s: "verification code".tr,
                        size: 16,
                        fw: FontWeight.w400,
                        clr: Colr.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: OtpTextField(
                      numberOfFields: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      borderColor: Colr.primary,
                      cursorColor: Colors.black,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      focusedBorderColor:
                          const Color.fromARGB(255, 211, 141, 136),
                      showFieldAsBox: true,
                      autoFocus: true,
                      onCodeChanged: (value) {
                        confirmationcodeController.text = value;
                        if (value == '') {
                          setState(() {
                            isValid = false;
                          });
                          Fluttertoast.showToast(
                              msg: 'Fill all the OTP fields'.tr);
                        }
                      },
                      onSubmit: (String verificationCode) {
                        setState(() {
                          isValid = true;
                          confirmationcodeController.text = verificationCode;
                        });
                      },
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  SVProgressHUD.setForegroundColor(Colr.primary);
                  SVProgressHUD.setRingThickness(5.5);
                  SVProgressHUD.setCornerRadius(0.5);
                  SVProgressHUD.setCornerRadius(0.5);
                  SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom);
                  SVProgressHUD.show();
                  Future.delayed(const Duration(seconds: 3)).then((value) {
                    SVProgressHUD.dismiss();
                  });
                  loginController.otpResend(context, widget.mobile,
                      widget.logRegChk, widget.businessId);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: CommenTextWidget(
                    s: "I did not get. Sent me again".tr,
                    size: 18,
                    fw: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: confirmationcodeController.text.length == 6
                        ? Colr.primary
                        : const Color.fromRGBO(242, 242, 242, 1),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            confirmationcodeController.text.length == 6
                                ? Colr.primary
                                : const Color.fromRGBO(242, 242, 242, 1),
                        padding: const EdgeInsets.symmetric(vertical: 30),
                      ),
                      onPressed: () {
                        if (confirmationcodeController.text.length == 6) {
                          setState(() {
                            isValid = true;
                          });
                        }

                        if (isValid) {
                          SVProgressHUD.setForegroundColor(Colr.primary);
                          SVProgressHUD.setRingThickness(5.5);
                          SVProgressHUD.setCornerRadius(0.5);
                          SVProgressHUD.setCornerRadius(0.5);
                          SVProgressHUD.setDefaultStyle(
                              SVProgressHUDStyle.custom);
                          SVProgressHUD.show();
                          Future.delayed(const Duration(seconds: 3))
                              .then((value) {
                            SVProgressHUD.dismiss();
                          });
                          var data = {
                            "mobile": widget.mobile,
                            "otp": int.parse(confirmationcodeController.text),
                          };

                          if (widget.logRegChk == 'Login') {
                         
                            loginController
                                .getUserAuthenticate(data,isBusinessIdExists,businessId: widget.businessId)
                                .then((value) async {
                              if (value != null) {
                                if (value != 500) {
                                  if (value == 200) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: ((context) => HomeScreen(
                                                  selectedIndex: 2,
                                                ))));
                                    Fluttertoast.showToast(
                                        msg: 'Logged In Successfully !!'.tr);
                                  }
                                }
                              }
                            });
                          } else if (widget.logRegChk == 'Register') {
                            api.LoginServices.getRegisterOtpAuthenticate(data)
                                .then((value) async {
                              if (value != 500) {
                                if (value == 200) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => RegisterScreen(
                                            mobile: widget.mobile,
                                          ))));
                                }
                              } else {
                                Fluttertoast.showToast(msg: 'Invalid OTP'.tr);
                              }
                            });
                          }

                          // },
                        }
                        // trying to move to the bottom
                      },
                      child: CommenTextWidget(
                        s: "Continued".tr,
                        size: 18,
                        fw: FontWeight.w700,
                        clr: confirmationcodeController.text.length == 6
                            ? Colr.primaryLight
                            : Colr.secondaryGrey,
                      ),
                    ),
                  ),
                ),
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
      onPressed: () => Get.back(),
    );
  }

  Future<void> fetchLocalDb() async {
    await customerController.getToken();
    await customerController.getUserInformation();
  }
}

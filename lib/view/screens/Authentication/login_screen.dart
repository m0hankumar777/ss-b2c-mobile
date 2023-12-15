import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/controller/login_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/utility/widget_helper/custom_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  bool isLoginCLicked;
    int? businessId;
  LoginScreen({required this.isLoginCLicked, this.businessId,super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final localizationController = Get.put(LocalizationController());
  final loginController = Get.put(LoginController());
  final TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var data;
  String? logReg;
  String? test;

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = '';
    phoneNumberController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      elevation: 5,
      color: phoneNumberController.text.length < 10
          ? Colr.primaryLight
          : Colr.primary,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 30),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          final isValid = _formKey.currentState!.validate();

          if (isValid) {
            data = phoneNumberController.text;
            SVProgressHUD.setForegroundColor(Colr.primary);
            SVProgressHUD.setRingThickness(5.5);
            SVProgressHUD.setCornerRadius(0.5);
            SVProgressHUD.setCornerRadius(0.5);
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom);
            SVProgressHUD.show();
            Future.delayed(const Duration(seconds: 3)).then((value) async {
                 // ignore: unused_local_variable
                //  final String signature = await SmsAutoFill().getAppSignature;
              // ignore: use_build_context_synchronously
              loginController.authLogin(context, data, widget.isLoginCLicked,widget.businessId);
            
              SVProgressHUD.dismiss();
            });
          }
        },
        child: CommenTextWidget(
          s: "Send me a verification code".tr,
          size: 18,
          fw: FontWeight.w700,
          clr: phoneNumberController.text.length < 10
              ? const Color.fromRGBO(130, 130, 130, 1)
              : Colr.primaryLight,
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
          s: "Cellphone number".tr,
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
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommenTextWidget(
                      s: "Please enter a phone number for identification and to receive personal messages about your appointments."
                          .tr,
                      size: 18,
                      fw: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: CommenTextWidget(
                        s: "Phone Number".tr,
                        size: 16,
                        fw: FontWeight.w400,
                        clr: Colr.primary,
                      ),
                    ),
                    CustomTextFormFieldWidget(
                      validatorFn: (value) {
                        if (value!.isEmpty) {
                          return "This Field can't be empty".tr;
                        }
                        if (!(value.startsWith('05'))) {
                          return 'Number should starts with 05'.tr;
                        }
                        if (value.length < 10) {
                          return 'Enter valid phone number'.tr;
                        }

                        return null;
                      },
                      onSaved: (value) {
                        phoneNumberController.text = value!;
                        data = value;
                      },
                      controller: phoneNumberController,
                      keyboardtype: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      color: Colr.primary,
                      inputDecoration: InputDecoration(
                        focusColor: Colr.primary,
                        fillColor: Colr.primary,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colr.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colr.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      color: phoneNumberController.text.length < 10
                          ? Colr.primaryLight
                          : Colr.primary,
                      width: double.infinity,
                      child: loginButton),
                ),
              ),
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
}

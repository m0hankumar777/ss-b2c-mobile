import 'dart:convert';

import 'package:B2C/services/Authentication/login_service.dart';
import 'package:B2C/view/screens/Authentication/otp_screen.dart';
import 'package:B2C/view/screens/OnBoardingScreens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:B2C/const/url.dart' as apiurl;

import '../model/Authentication/customer_model.dart';

class LoginController extends GetxController {
  String? msg;
  String? logReg;
  Rx<CustomerModel> userModel = CustomerModel().obs;
  getUserAuthenticate(Map data, bool isBusinessIdExists,
      {int? businessId}) async {
    var user = await LoginServices()
        .getOtpAuthenticate(data, isBusinessIdExists, businessId: businessId);
    if (user != 0 && user != 500 && user != 400 && user != true) {
      userModel.value = user as CustomerModel;
    }
  }

  Future<void> authLogin(BuildContext context, String data, bool isLoginClicked,
      int? businessId) async {
    getgenerateotp(data, isLoginClicked).then((value) async {
      if (value == 200 && logReg == 'Register' && isLoginClicked == true) {
        Fluttertoast.showToast(msg: 'Phone number does not exist'.tr);
        Get.offAll(const IntroScreen());
      } else if (value == 200 && logReg == 'Login' && isLoginClicked == false) {
        Get.offAll(const IntroScreen());

        Fluttertoast.showToast(msg: 'Phone Number Already Exists'.tr);
      } else if (value == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => OtpScreen(
                mobile: data,
                logRegChk: '$logReg',
                message: '$msg',
                businessId: businessId))));
      } else if (value == 500) {
        Fluttertoast.showToast(msg: 'Phone Number not Registered !!!'.tr);
      } else if (value == 90) {
        Fluttertoast.showToast(
            msg: 'Business not approved, contact support'.tr);
      } else {
        Fluttertoast.showToast(msg: 'Internal Server Error'.tr);
      }
    });
  }

  Future<int> getgenerateotp(String mobileNumber, bool isLoginClicked) async {
    final body = {
      'phoneNumber': mobileNumber,
      'isLoginClicked': isLoginClicked
    };
    final headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    final response = await http.post(
      Uri.parse(apiurl.baseUrl + apiurl.generateOtp),
      headers: headers,
      body: jsonEncode(body),
    );
    Map result = await jsonDecode(response.body);
    logReg = result["MaxNo"];
    msg = result['Message'];
    if (response.statusCode == 200) {
      Map result = await jsonDecode(response.body);

      return result["StatusCode"];
    } else {
      return response.statusCode;
    }
  }

  Future<void> otpResend(BuildContext context, String data,
      String isLoginClicked, int? businessId) async {
    getgenerateotp(data, isLoginClicked == 'Register' ? false : true)
        .then((value) async {
      if (value == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: ((context) => OtpScreen(
                  mobile: data,
                  logRegChk: '$logReg',
                  message: '$msg',
                  businessId: businessId,
                ))));
      } else if (value == 500) {
        Fluttertoast.showToast(msg: 'Phone Number not Registered !!!'.tr);
      } else if (value == 90) {
        Fluttertoast.showToast(
            msg: 'Business not approved, contact support'.tr);
      } else {
        Fluttertoast.showToast(msg: 'Internal Server Error'.tr);
      }
    });
  }
}

var box = Hive.box('login');
bool getLoginStatus() {
  String logcheck = box.get('isLogin') ?? '';
  if (logcheck != '') {
    return true;
  } else {
    return false;
  }
}

getToken() {
  var box = Hive.box('login');
  String? token = box.get('token');
  return token;
}

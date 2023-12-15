// ignore: file_names
import 'dart:convert';

import 'package:B2C/const/url.dart' as apiurl;
import 'package:B2C/view/screens/Authentication/login_screen.dart';
import 'package:B2C/view/screens/Business/business_about_screen.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../controller/customer_controller.dart';
import '../../controller/profile_controller.dart';
import '../../model/Authentication/customer_model.dart';

class LoginServices {
  final profileController = Get.put(ProfileController());
  final customerController = Get.put(CustomerController());

  // static Future<int> getgenerateotpRegister(String mobileNumber) async {
  //   final body = {
  //     'phoneNumber': mobileNumber,
  //   };
  //   final headers = {
  //     "Accept": "application/json",
  //     "content-type": "application/json"
  //   };

  //   final response = await http.post(
  //     Uri.parse(apiurl.baseUrl + apiurl.generateOtp),
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );

  //   if (response.statusCode == 200) {
  //     return 200;
  //   } else {
  //     return response.statusCode;
  //   }
  // }

  Future getOtpAuthenticate(Map data, bool isBusinessIdExists,
      {int? businessId}) async {
    String url = apiurl.baseUrl + apiurl.otpAuthentication;
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (result["issuccess"] == true && result['token'] != null) {
        if (isBusinessIdExists) {
          Get.back();
          Get.back();
          Get.back();
          Get.to(() => BusinessAboutScreen(businessId!, false));
        } else {
          Get.offAll(HomeScreen(
            selectedIndex: 2,
          ));
        }

        Fluttertoast.showToast(msg: 'Loggedin Successfully'.tr);
        CustomerModel custModel = customerModelFromJson(response.body);
        customerController.custInfo.value = custModel.customer!;
        Box<Customer> box = Hive.box<Customer>('customer');
        Box box1 = Hive.box('login');
        box.put('userInfo', custModel.customer!);
        box1.put('isLogin', 'yes');
        box1.put('token', custModel.token);
        profileController.userInOrOut.value = true;
        return custModel;
      }
      if (result["errorMessage"] == null && result["statusCode"] == 0) {
        return Fluttertoast.showToast(msg: 'Invalid OTP'.tr);
      }
      if (result["errorMessage"] == 'Declined user') {
        return 0;
      } else {
        return 500;
      }
    } else {
      return 400;
    }
  }

  static Future<int> getRegisterOtpAuthenticate(Map data) async {
    String url = apiurl.baseUrl + apiurl.otpAuthentication;
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (result["issuccess"] == true && result['token'] == null) {
        return 200;
      }
      if (result["errorMessage"] == 'Declined user') {
        return 0;
      } else {
        return 500;
      }
    } else {
      return response.statusCode;
    }
  }

  static Future<String> register(Map<String, dynamic> data) async {
    String url = apiurl.baseUrl + apiurl.register;
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
    if (response.statusCode == 200) {
      Map result = await jsonDecode(response.body);
      if (result["issuccess"] == true) {
        Fluttertoast.showToast(msg: "Registered Successfully".tr);

        Get.offAll(() => LoginScreen(
              isLoginCLicked: true,
            ));
        return "200";
      } else if (result["statusCode"] == 400) {
        return result["message"];
      } else {
        return "500";
      }
    } else {
      return "500";
    }
  }
}

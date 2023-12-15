import 'dart:convert';

import 'package:B2C/const/url.dart' as apiurl;
import 'package:B2C/model/profile/profile_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/login_controller.dart';

class ProfileServices {
  final loginController = Get.put(LoginController());

  Future<int> updateGender(Map<String, dynamic> data) async {
    String url = "${apiurl.baseUrl}Profile/AddCustomerGender";
    final response = await http.put(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 300;
    }
  }

  Future<bool> updateD0B(Map<String, dynamic> data) async {
    String url = "${apiurl.baseUrl}Profile/AddCustomerDOB";
    final response = await http.put(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result["Status"];
    } else {
      return false;
    }
  }

  Future<String> deleteClientApi(int clientId) async {
    String url = "${apiurl.baseUrl}Payment/DeleteAccount?customerId=$clientId";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

   
    if (response.statusCode == 200) {
      String result = jsonDecode(response.body);
   
      return result;
    } else {
      return "";
    }
  }

  Future<bool> updateFirstName(Map<String, dynamic> data) async {
    String url = "${apiurl.baseUrl}Profile/AddCustomerFirstName";
    final response = await http.put(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result["Status"];
    } else {
      return false;
    }
  }

  Future<bool> updateLastName(Map<String, dynamic> data) async {
    String url = "${apiurl.baseUrl}Profile/AddCustomerLastName";
    final response = await http.put(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result["Status"];
    } else {
      return false;
    }
  }

  Future<bool> updateEmail(Map<String, dynamic> data) async {
    String url = "${apiurl.baseUrl}Profile/AddCustomerEmail";
    final response = await http.put(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result["Status"];
    } else {
      return false;
    }
  }

  Future getProfileInformation(int id) async {
    String url =
        "${apiurl.baseUrl}Profile/GetProfileDetailByCustomerId?customerid=$id";
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      ProfileModel result = profileModelFromJson(response.body);
      return result;
    }
  }
}

import 'dart:convert';

import 'package:B2C/controller/appointmentlist_controller.dart';
import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/model/BookAppointment/available_dates_model.dart';
import 'package:B2C/model/BookAppointment/available_slots_model.dart';
import 'package:B2C/model/BookAppointment/promo_code_model.dart';
import 'package:B2C/model/BookAppointment/success_appointment.dart';
import 'package:B2C/model/profile/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:B2C/const/url.dart' as apiurl;

import '../../model/Business/business_staff_model.dart';

class BookAppointmentServices {
  final customerController = Get.put(CustomerController());
  final appointmentListController = Get.put(AppointmentListController());
  Future<List<StaffModel>> getAvailableStaffForService(
      int businessId, List<Map> serviceId) async {
    String url =
        "${apiurl.baseUrl}Profile/GetAvailableStaffs?businessId=$businessId";

    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(serviceId));

    if (response.statusCode == 200) {
      return staffModelFromJson(response.body);
    }
    return [];
  }

  Future<String> getPaymentUrl() async {
    String url =
        "${apiurl.baseUrl}Payment/ApiCheckForCardPayment?customerId=${customerController.custInfo.value.id}";
    final response = await http.get(Uri.parse(url));
    var result = "";
    if (response.statusCode == 200) {
      result = response.body;
    } else {
      result = "";
    }
    return result;
  }

  Future<Map> getCardDetails() async {
    String url =
        "${apiurl.baseUrl}Payment/GetCardDetailsById?cid=${customerController.custInfo.value.id}";
    final response = await http.get(Uri.parse(url));
    var result = {};

    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    }
    return result;
  }

  Future<List<AvailableSlotModel>> getAvailableSlot(
      int businessId, int staffId, String date, List serviceList) async {
    String url =
        "${apiurl.baseUrl}Profile/GetStaffavailableTime?StaffId=$staffId&calSelectedDate=$date&businessId=$businessId";

    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(serviceList));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "staff not available") {
     
        return [];
      } else {
        return availableSlotModelFromJson(response.body);
      }
    }
    return [];
  }

  Future<SuccessAppointmentModel?> bookAppointmentApi(Map data) async {
    DateTime createdOn = DateTime.now();
    final url =
        "${apiurl.baseUrl}Payment/BookAppointmentDetail?Date=${createdOn.toIso8601String()}";
    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      return successAppointmentModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<String> editAppointmentApi(Map data,double lat,double long) async {
    DateTime createdOn = DateTime.now();
    final url =
        "${apiurl.baseUrl}Payment/EditAppointment?Date=${createdOn.toIso8601String()}";
    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "success") {
        appointmentListController
            .getAppointnentsData(customerController.custInfo.value.id!,lat,long);
        return response.body;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<List<PromoCodeModel>> getPromoCode() async {
    String url =
        "${apiurl.baseUrl}Payment/Promocode?customerId=${customerController.custInfo.value.id}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return promoCodeModelFromJson(response.body);
    }
    return [];
  }

  Future<List<AvailableDatesModel>> getAvailableDatesForStaff(
      int staffId, int businessId) async {
    String url =
        "${apiurl.baseUrl}Profile/GetStaffavailableDates?StaffId=$staffId&businessId=$businessId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return availableDatesModelFromJson(response.body);
    }
    return [];
  }

  Future getCreditCardDetail(int id) async {
    String url = "${apiurl.baseUrl}Payment/GetCardDetailsById?cid=$id";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return paymentDetailsModelFromJson(response.body);
    } else {
      return 204;
    }
  }
}

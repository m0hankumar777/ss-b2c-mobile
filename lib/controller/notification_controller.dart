import 'package:B2C/const/url.dart' as apiurl;
import 'package:B2C/model/Menu/menu_notification_model.dart';

import 'package:http/http.dart' as http;

import 'package:get/get.dart';

class NotificationController extends GetxController {
  Rx<NotificationModel> smsnotification = NotificationModel().obs;

  Future<int> checkNotification(int id, bool notify) async {
    String url =
        "${apiurl.baseUrl}Profile/UpdateProfileSettingSMS?notify=$notify&customerid=$id";
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 500;
    }
  }

  Future<int> checkPushNotification(
      int id, bool notify, String dateTime) async {
    String url =
        "${apiurl.baseUrl}Profile/PushNotificationSMS?notify=$notify&customerid=$id&Date=$dateTime";
    final response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 500;
    }
  }

  Future getNotificatonCustomerByID(int id) async {
    NotificationModel notifications;
    String url =
        "${apiurl.baseUrl}Profile/GetNotificationByCustomerId?customerid=$id";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      notifications = notificationModelFromJson(response.body);
      smsnotification.value = notifications;
    }
  }
}

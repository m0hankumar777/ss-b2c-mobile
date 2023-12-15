import 'package:B2C/const/url.dart' as apiurl;
import 'package:B2C/model/Home/home_categories_model.dart';
import 'package:B2C/model/Home/home_clientreviews_model.dart';
import 'package:B2C/model/Home/home_notifications_model.dart';
import 'package:B2C/model/Home/home_recommendedsalons_model.dart';
import 'package:http/http.dart' as http;

import '../../model/Home/home_appointmentsdetail_model.dart';
import '../../model/Home/home_subcategories_model.dart';

class HomeScreenService {
  Future<List<CategoriesModel>> getCategories() async {
    String url = "${apiurl.baseUrl}Home/GetAllCategories";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<CategoriesModel> result = categoriesModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future<List<SubCategoriesModel>> getSubCategories(int categoryId) async {
    String url =
        "${apiurl.baseUrl}Home/GetSubCategories?categoryId=$categoryId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<SubCategoriesModel> result =
          subCategoriesModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future<List<RecommendedSalonsModel>> getRecommendedSalons(
      double lat, double long) async {
    String url =
        "${apiurl.baseUrl}Home/GetRecommendedSalons?latitude=$lat&longitude=$long";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<RecommendedSalonsModel> result =
          recommendedSalonsModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future<String?> getClientReviewCount() async {
    String url = "${apiurl.baseUrl}Home/GetProductReviewCount";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  Future<List<ClientReviewsModel>> getClientReviews() async {
    String url = "${apiurl.baseUrl}Home/GetProductReview";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<ClientReviewsModel> result =
          clientReviewsModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future<List<NotificationsModel>> getAllNotifications(int customerId) async {
    String url = "${apiurl.baseUrl}Profile/Notification?customerId=$customerId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<NotificationsModel> result =
          notificationsModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future getAppointmentDetailsByNotification(int appointmentId) async {
    String url =
        "${apiurl.baseUrl}Profile/GetNotificationDetailsById?appointId=$appointmentId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      AppointmentDetailsModel result =
          appointmentDetailsModelFromJson(response.body);
      return result;
    } else {
      return 0;
    }
  }

  Future<int> isNotificationRead(int notificationId) async {
    String url =
        "${apiurl.baseUrl}Profile/NotificationRead?notificationId=$notificationId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (response.body == "success") {
        return 200;
      } else {
        return 500;
      }
    } else {
      return 500;
    }
  }

  getUnreadNotificationsCount(int customerId) async {
    String url =
        "${apiurl.baseUrl}Profile/NotificationUnreadCount?customerId=$customerId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}

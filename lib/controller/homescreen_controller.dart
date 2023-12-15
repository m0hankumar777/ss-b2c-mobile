import 'package:B2C/model/Home/home_categories_model.dart';
import 'package:B2C/model/Home/home_clientreviews_model.dart';
import 'package:B2C/model/Home/home_recommendedsalons_model.dart';
import 'package:get/get.dart';

import '../model/Home/home_appointmentsdetail_model.dart';
import '../model/Home/home_subcategories_model.dart';
import '../model/Home/home_notifications_model.dart';
import '../services/HomeScreen/homescreen_service.dart';

class HomeScreenController extends GetxController {
  HomeScreenService homeScreenService = HomeScreenService();
  var categories = <CategoriesModel>[].obs;
  var subCategories = <SubCategoriesModel>[].obs;
  var recommendedSalons = <RecommendedSalonsModel>[].obs;
  var clientReviews = <ClientReviewsModel>[].obs;
  var notifications = <NotificationsModel>[].obs;
  Rx<AppointmentDetailsModel> appointmentDetails = AppointmentDetailsModel().obs;
  var notificationsCount = ''.obs;
  var clientCount = ''.obs;

  // var bestRatedSalons = <BestRatedSalonsModel>[].obs;

  Future getAllCategories() async {
    categories.value = await homeScreenService.getCategories();
    if (categories.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }

  Future getAllSubCategories(int categoryId) async {
    subCategories.value = await homeScreenService.getSubCategories(categoryId);
    if (subCategories.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }

  Future getRecommendedSalons(double lat, double long) async {
    recommendedSalons.value = await homeScreenService.getRecommendedSalons(lat,long);
    if (recommendedSalons.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }

  Future getClientReviewCount() async {
    clientCount.value = (await homeScreenService.getClientReviewCount())!;
    // ignore: unnecessary_null_comparison
    if (clientCount != null) {
      return 200;
    } else {
      return 300;
    }
  }

  Future getClientReviews() async {
    clientReviews.value = await homeScreenService.getClientReviews();
    if (clientReviews.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }

  Future getAllNotifications(int customerId) async {
    notifications.value =
        (await homeScreenService.getAllNotifications(customerId));
    if (notifications.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }
  Future getAppointmentDetailsByNotification(int appointmentId) async {
    appointmentDetails.value =
        (await homeScreenService.getAppointmentDetailsByNotification(appointmentId));
  }

  Future isNotificationRead(int notificationId) async {
    int isNotified = await homeScreenService.isNotificationRead(notificationId);
    if (isNotified == 200) {
      return 200;
    } else {
      return 500;
    }
  }

  getUnreadNotificationsCount(int customerId) async {
    notificationsCount.value =
        await homeScreenService.getUnreadNotificationsCount(customerId);
  }

  // Future getBestRatedSalons() async {
  //   bestRatedSalons.value = await homeScreenService.getBestRatedSalons();
  //   if (bestRatedSalons.isNotEmpty) {
  //     return 200;
  //   } else {
  //     return 300;
  //   }
  // }
}

import 'dart:convert';

import 'package:B2C/model/Business/Services/business_subcategory_model.dart';
import 'package:http/http.dart' as http;
import 'package:B2C/const/url.dart' as apiurl;

import '../../model/Business/business_about_model.dart';
import '../../model/Business/business_faq_model.dart';
import '../../model/Business/business_reviews_model.dart';
import '../../model/Business/Services/business_gallery_model.dart';

class BusinessAboutService {
  Future getBusinessData(int businessId, lati, longi) async {
    String url =
        "${apiurl.baseUrl}Product/GetProductById?id=$businessId&latitude=$lati&longitude=$longi";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      BusinessAboutModel result = businessAboutModelFromJson(response.body);
      return result;
    }
  }

  Future<List<BusinessReviewsModel>> getReviews(
      int businessId, int categoryId) async {
    String url =
        "${apiurl.baseUrl}Home/GetAllReviews?productId=$businessId&categoryId=$categoryId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (response.body != '') {
        List<BusinessReviewsModel> result =
            businessReviewsModelFromJson(response.body);
        return result;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<List<BusinessFaqModel>> getFaq(int businessId, int categoryId) async {
    String url =
        "${apiurl.baseUrl}Home/GetFaq?businessId=$businessId&categoryId=$categoryId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<BusinessFaqModel> result = businessFaqModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future getCategoryImages(int businessId, int catId) async {
    String url =
        "${apiurl.baseUrl}Home/GetGallery?CategoryId=$catId&Id=$businessId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<GallaryModel> result = gallaryModelFromJson(response.body);
      return result;
    } else {
      return [];
    }
  }

  Future<List<SubCategoryModel>> getServices(
    int buisnessId,
    int catId,
  ) async {
    String url =
        "${apiurl.baseUrl}Product/GetServiceDataByCategoryAndBusinessId?businessId=$buisnessId&categoryId=$catId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<SubCategoryModel> services = subCategoryModelFromJson(response.body);
      return services;
    } else {
      return [];
    }
  }

  Future<int> postReviews(Map reviewsMap) async {
    String url = "${apiurl.baseUrl}Product/WriteAReview";
    final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "text/plain",
          "content-type": "application/json-patch+json"
        },
        body: jsonEncode(reviewsMap));
    if (response.statusCode == 200) {
      var result = await jsonDecode(response.body);
      if (result["Status"]) {
        return 200;
      } else {
        return 500;
      }
    } else {
      return 500;
    }
  }

  Future<bool> reviewValidate(int productId, int customerId) async {
    String url =
        "${apiurl.baseUrl}Product/ReviewValidate?productId=$productId&customerId=$customerId";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "text/plain",
        "content-type": "application/json-patch+json"
      },
    );
    if (response.statusCode == 200) {
      var result = await jsonDecode(response.body);
      return result;
    } else {
      return false;
    }
  }
}

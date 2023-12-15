import 'dart:async';
import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/model/Search/search_product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../const/url.dart' as apiurl;

class SearchController extends GetxController {
  RxList<SearchProductModel> searchDetails = <SearchProductModel>[].obs;
  RxInt menuItem = 0.obs;
  RxList<SearchProductModel> nearbySalons = <SearchProductModel>[].obs;
  RxList<SearchProductModel> bestRatedSalons = <SearchProductModel>[].obs;
  final localizationController = Get.put(LocalizationController());
  final customerController = Get.put(CustomerController());

  RxList<String> allsearchCategory = <String>[].obs;
  RxList<String> allsearchLocation = <String>[].obs;

  Rx<String> subCategory = "".obs;

  RxBool isLoading = false.obs;
  bool supportRTl = false;

  List<String> allLocationDummy = [];
  List<String> allSearchDummy = [];

  Future searchSalonOrServices(dynamic pageKey, int pageSize, String searchTerm,
      double latitude, double longitude) async {
    List<SearchProductModel> ssearchDetails;
    supportRTl = localizationController.isHebrew.value ? true : false;
    var customerId = customerController.custInfo.value.id ?? 0;
    try {
      String url =
          "${apiurl.baseUrl}Services/SearchBySalonOrServices?pageNo=$pageKey&pageSize=$pageSize&name=$searchTerm&latitude=$latitude&longitude=$longitude&supportRTl=$supportRTl&customerId=$customerId";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        ssearchDetails = searchProductModelFromJson(response.body);
        searchDetails.value = ssearchDetails;
        isLoading.value = true;
      } else {
        // ignore: avoid_print
        print('response ------------ 206');
      }

      return response.statusCode;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return 500;
    }
  }

  Future searchByLocation(dynamic pageKey, int pageSize, String searchTerm,
      double latitude, double longitude) async {
    List<SearchProductModel> ssearchDetails;
    supportRTl = localizationController.isHebrew.value ? true : false;
    var customerId = customerController.custInfo.value.id ?? 0;

    try {
      // ignore: prefer_interpolation_to_compose_strings
      String url = apiurl.baseUrl +
          "Services/SearchByLocation?pageNo=$pageKey&pageSize=$pageSize&searchTerms=$searchTerm&latitude=$latitude&longitude=$longitude&supportRTl=$supportRTl&customerId=$customerId";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = response.body;
        // ignore: await_only_futures
        ssearchDetails = await searchProductModelFromJson(responseBody);
        searchDetails.value = ssearchDetails;
        return response.statusCode;
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future search(int pageKey, int pageSize, String searchTerm,
      String locationSearch, double latitude, double longitude) async {
    List<SearchProductModel> ssearchDetails;
    supportRTl = localizationController.isHebrew.value ? true : false;
    var customerId = customerController.custInfo.value.id ?? 0;

    try {
      String url =
          "${apiurl.baseUrl}Services/Search?pageNo=$pageKey&pageSize=$pageSize&searchTerms=$searchTerm&locationQuery=$locationSearch&latitude=$latitude&longitude=$longitude&supportRTl=$supportRTl&customerId=$customerId";
      // ignore: avoid_print
      print("Url - $url");
      final response = await http.get(Uri.parse(url));
      // ignore: avoid_print
      print("Response Body - ${response.body}");
      if (response.statusCode == 200) {
        // ignore: await_only_futures
        ssearchDetails = await searchProductModelFromJson(response.body);
        searchDetails.value = ssearchDetails;
        return 200;
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future getAllSearchLocation() async {
    List<String> ssearchDetails = [];
    try {
      // ignore: prefer_interpolation_to_compose_strings
      String url = apiurl.baseUrl + "Services/GetAutoLocation";
      // ignore: avoid_print
      print("Url - $url");
      final response = await http.get(Uri.parse(url));
      // ignore: avoid_print
      print("Response getAllSearchCategory - ${response.body}");
      if (response.statusCode == 200) {
        ssearchDetails =
            (jsonDecode(response.body) as List<dynamic>).cast<String>();
        allsearchLocation.value = ssearchDetails;
      }
      // ignore: unused_catch_clause
    } on TimeoutException catch (e) {
      allsearchLocation.value = ssearchDetails;
    } catch (e) {
      allsearchLocation.value = ssearchDetails;
    }
    return ssearchDetails;
  }

  Future getAllSearchCategory() async {
    List<String> searchDetails = [];
    try {
      String url = "${apiurl.baseUrl}Services/GetAutoSalonAndServices";
      // ignore: avoid_print
      print("Url - $url");
      final response = await http.get(Uri.parse(url));
      // ignore: avoid_print
      print("Response getAllSearchLocation - ${response.body}");
      if (response.statusCode == 200) {
        searchDetails =
            (jsonDecode(response.body) as List<dynamic>).cast<String>();
        allsearchCategory.value = searchDetails;
      }
    } catch (e) {
      allsearchCategory.value = searchDetails;
    }
    return searchDetails;
  }

  Future getSalonandSservices(String term) async {
    supportRTl = localizationController.isHebrew.value ? true : false;

    List<String> searchDetails = [];
    try {
      // ignore: prefer_interpolation_to_compose_strings
      String url = apiurl.baseUrl +
          "Services/GetSalonandSservices?term=$term&sRtl=$supportRTl";
      // ignore: avoid_print
      print("Url - $url");
      final response = await http.get(Uri.parse(url));
      // ignore: avoid_print
      print("Response getAllSearchLocation - ${response.body}");
      if (response.statusCode == 200) {
        searchDetails =
            (jsonDecode(response.body) as List<dynamic>).cast<String>();
        allsearchCategory.value = searchDetails;
      }
    } catch (e) {
      allsearchCategory.value = searchDetails;
    }
    return searchDetails;
  }

  Future getLocations(String term) async {
    supportRTl = localizationController.isHebrew.value ? true : false;

    List<String> searchDetails = [];
    try {
      String url =
          "${apiurl.baseUrl}Services/GetLocations?term=$term&sRtl=$supportRTl";
      // ignore: avoid_print
      print("Url - $url");
      final response = await http.get(Uri.parse(url));
      // ignore: avoid_print
      print("Response getAllSearchLocation - ${response.body}");
      if (response.statusCode == 200) {
        searchDetails =
            (jsonDecode(response.body) as List<dynamic>).cast<String>();
        allsearchLocation.value = searchDetails;
      }
    } catch (e) {
      allsearchLocation.value = searchDetails;
    }
    return searchDetails;
  }

  Future getBestRatedSalons(
      int pageKey, int pageSize, double latitude, double longitude) async {
    List<SearchProductModel> ssearchDetails;
    try {
      String url =
          "${apiurl.baseUrl}Services/BestRecommendedSalons?latitude=$latitude&longitude=$longitude";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = response.body;
        // ignore: await_only_futures
        ssearchDetails = await searchProductModelFromJson(responseBody);
        bestRatedSalons.value = ssearchDetails;
        searchDetails.value = ssearchDetails;
        return response.statusCode;
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future getNearBySalons(String searchTerm) async {
    List<SearchProductModel> searchDetails;
    try {
      String url =
          "${apiurl.baseUrl}Services/SearchByLocation?searchTerms=$searchTerm";

      // String url =
      //     "http://dev.glamz.com:9009/Services/SearchByLocation?searchTerms=Herzliya&supportRTl=false";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = response.body;
        // ignore: await_only_futures
        searchDetails = await searchProductModelFromJson(responseBody);
        nearbySalons.value = searchDetails;
        return response.statusCode;
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}

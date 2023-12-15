import 'package:B2C/model/Business/Services/business_subcategory_model.dart';
import 'package:get/get.dart';

import '../model/Business/business_about_model.dart';
import '../model/Business/business_faq_model.dart';
import '../model/Business/business_reviews_model.dart';
import '../model/Business/Services/business_gallery_model.dart';
import '../services/Business/businessabout_service.dart';

class BusinessController extends GetxController {
  BusinessAboutService businessservice = BusinessAboutService();
  Rx<BusinessAboutModel> businessData = BusinessAboutModel().obs;
  RxInt buisnessId = 0.obs;
  RxList<SubCategoryModel> subCategoryList = <SubCategoryModel>[].obs;
  RxList<BusinessFaqModel> faq = <BusinessFaqModel>[].obs;
  RxList<BusinessReviewsModel> reviews = <BusinessReviewsModel>[].obs;
  RxList<BusinessReviewsModel> allReviews = <BusinessReviewsModel>[].obs;
  RxList<GallaryModel> categoryImages = <GallaryModel>[].obs;
  RxList<GallaryModel> allGalleryImages = <GallaryModel>[].obs;
  RxBool isImage = false.obs;

  Future getBusinessData(int businessId, lati, longi) async {
    businessData.value = await businessservice.getBusinessData(businessId,lati,longi);
  }

  Future getAllSubCategoriesServices(int buisnessId, int categoryId) async {
    subCategoryList.value =
        await businessservice.getServices(buisnessId, categoryId);
    if (subCategoryList.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }

  getServices(
    int catId,
    int buisnessId,
  ) async {
    subCategoryList.value =
        await BusinessAboutService().getServices(buisnessId, catId);
  }

  Future getReviews(int businessId, int categoryId) async {
    reviews.value = await businessservice.getReviews(businessId, categoryId);
  }

  Future getAllReviews(int businessId, int categoryId) async {
    allReviews.value = await businessservice.getReviews(businessId, categoryId);
  }

  Future getFaq(int businessId, int categoryId) async {
    faq.value = await businessservice.getFaq(businessId, categoryId);
  }

  Future getCategoryImages(int bId, int cId) async {
    categoryImages.value = await businessservice.getCategoryImages(bId, cId);
    if (categoryImages.isNotEmpty) {
      isImage.value = true;
    } else {
      isImage.value = false;
    }
  }

  Future getAllCategoryImages(int bId, int cId) async {
    allGalleryImages.value = await businessservice.getCategoryImages(bId, cId);
    if (allGalleryImages.isNotEmpty) {
      isImage.value = true;
    } else {
      isImage.value = false;
    }
  }

  Future<int> postReviews(Map reviewsMap) async {
    return await businessservice.postReviews(reviewsMap);
  }
  Future<bool> reviewValidate(int productId, int customerId) async {
    return await businessservice.reviewValidate(productId,customerId);
  }
}

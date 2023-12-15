// To parse this JSON data, do
//
//     final businessAboutModel = businessAboutModelFromJson(jsonString);

import 'dart:convert';

BusinessAboutModel businessAboutModelFromJson(String str) =>
    BusinessAboutModel.fromJson(json.decode(str));

String businessAboutModelToJson(BusinessAboutModel data) =>
    json.encode(data.toJson());

class BusinessAboutModel {
  BusinessAboutModel({
    this.salonDetail,
    this.businessWorkingHours,
    this.staffDetail,
    this.businessService,
    this.reviews,
    this.categories,
    this.coverPhoto,
    this.galleryPhoto,
    this.facilityType,
    this.customProperties,
  });

  SalonDetail? salonDetail;
  List<BusinessWorkingHour>? businessWorkingHours;
  List<StaffDetail>? staffDetail;
  List<BusinessService>? businessService;
  List<Review>? reviews;
  List<Category>? categories;
  List<Photo>? coverPhoto;
  List<Photo>? galleryPhoto;
  List<FacilityType>? facilityType;
  Custom? customProperties;

  factory BusinessAboutModel.fromJson(Map<String, dynamic> json) =>
      BusinessAboutModel(
        salonDetail: SalonDetail.fromJson(json["SalonDetail"]),
        businessWorkingHours: List<BusinessWorkingHour>.from(
            json["BusinessWorkingHours"]
                .map((x) => BusinessWorkingHour.fromJson(x))),
        staffDetail: List<StaffDetail>.from(
            json["StaffDetail"].map((x) => StaffDetail.fromJson(x))),
        businessService: List<BusinessService>.from(
            json["BusinessService"].map((x) => BusinessService.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        categories: List<Category>.from(
            json["Categories"].map((x) => Category.fromJson(x))),
        coverPhoto:
            List<Photo>.from(json["CoverPhoto"].map((x) => Photo.fromJson(x))),
        galleryPhoto: List<Photo>.from(
            json["GalleryPhoto"].map((x) => Photo.fromJson(x))),
        facilityType: List<FacilityType>.from(
            json["FacilityType"].map((x) => FacilityType.fromJson(x))),
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "SalonDetail": salonDetail!.toJson(),
        "BusinessWorkingHours":
            List<dynamic>.from(businessWorkingHours!.map((x) => x.toJson())),
        "StaffDetail": List<dynamic>.from(staffDetail!.map((x) => x.toJson())),
        "BusinessService":
            List<dynamic>.from(businessService!.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "Categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "CoverPhoto": List<dynamic>.from(coverPhoto!.map((x) => x.toJson())),
        "GalleryPhoto":
            List<dynamic>.from(galleryPhoto!.map((x) => x.toJson())),
        "FacilityType":
            List<dynamic>.from(facilityType!.map((x) => x.toJson())),
        "CustomProperties": customProperties?.toJson(),
      };
}

class BusinessService {
  BusinessService({
    this.id,
    this.businessId,
    this.businessServiceId,
    this.serviceId,
    this.serviceName,
    this.serviceNameH,
    this.subServiceName,
    this.subServiceNameH,
    this.duration,
    this.durationH,
    this.price,
    this.isAddedToCart,
    this.subService,
    this.businessSubServiceId,
    this.nopBusinessSubServiceId,
    this.isSubservice,
    this.customValues,
    this.customProperties,
  });

  int? id;
  int? businessId;
  int? businessServiceId;
  int? serviceId;
  String? serviceName;
  String? serviceNameH;
  // ignore: unnecessary_question_mark
  dynamic? subServiceName;
  // ignore: unnecessary_question_mark
  dynamic? subServiceNameH;
  String? duration;
  String? durationH;
  double? price;
  bool? isAddedToCart;
  // ignore: unnecessary_question_mark
  dynamic? subService;
  int? businessSubServiceId;
  int? nopBusinessSubServiceId;
  bool? isSubservice;
  Custom? customValues;
  Custom? customProperties;

  factory BusinessService.fromJson(Map<String, dynamic> json) =>
      BusinessService(
        id: json["Id"],
        businessId: json["BusinessId"],
        businessServiceId: json["BusinessServiceId"],
        serviceId: json["ServiceId"],
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
        subServiceName: json["SubServiceName"],
        subServiceNameH: json["SubServiceNameH"],
        duration: json["Duration"],
        durationH: json["DurationH"],
        price: json["Price"],
        isAddedToCart: json["isAddedToCart"],
        subService: json["SubService"],
        businessSubServiceId: json["BusinessSubServiceId"],
        nopBusinessSubServiceId: json["NopBusinessSubServiceId"],
        isSubservice: json["IsSubservice"],
        customValues: Custom.fromJson(json["CustomValues"]),
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "BusinessId": businessId,
        "BusinessServiceId": businessServiceId,
        "ServiceId": serviceId,
        "ServiceName": serviceName,
        "ServiceNameH": serviceNameH,
        "SubServiceName": subServiceName,
        "SubServiceNameH": subServiceNameH,
        "Duration": duration,
        "DurationH": durationH,
        "Price": price,
        "isAddedToCart": isAddedToCart,
        "SubService": subService,
        "BusinessSubServiceId": businessSubServiceId,
        "NopBusinessSubServiceId": nopBusinessSubServiceId,
        "IsSubservice": isSubservice,
        "CustomValues": customValues!.toJson(),
        "CustomProperties": customProperties!.toJson(),
      };
}

class Custom {
  Custom();

  factory Custom.fromJson(Map<String, dynamic> json) => Custom();

  Map<String, dynamic> toJson() => {};
}

class BusinessWorkingHour {
  BusinessWorkingHour({
    this.id,
    this.day,
    this.dayOfWeek,
    this.dayOfWeekH,
    this.fromWorkingHours,
    this.toWorkingHours,
    this.customProperties,
  });

  int? id;
  int? day;
  String? dayOfWeek;
  String? dayOfWeekH;
  String? fromWorkingHours;
  String? toWorkingHours;
  Custom? customProperties;

  factory BusinessWorkingHour.fromJson(Map<String, dynamic> json) =>
      BusinessWorkingHour(
        id: json["Id"],
        day: json["Day"],
        dayOfWeek: json["DayOfWeek"],
        dayOfWeekH: json["DayOfWeekH"],
        fromWorkingHours: json["FromWorkingHours"],
        toWorkingHours: json["ToWorkingHours"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Day": day,
        "DayOfWeek": dayOfWeek,
        "DayOfWeekH": dayOfWeekH,
        "FromWorkingHours": fromWorkingHours,
        "ToWorkingHours": toWorkingHours,
        "CustomProperties": customProperties!.toJson(),
      };
}

class Category {
  Category({
    this.subCategories,
    this.id,
    this.pictureId,
    this.imageUrl,
    this.categoryName,
    this.categoryNameH,
    this.customProperties,
  });

  List<SubCategory>? subCategories;
  int? id;
  int? pictureId;
  String? imageUrl;
  String? categoryName;
  String? categoryNameH;
  Custom? customProperties;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        subCategories: List<SubCategory>.from(
            json["SubCategories"].map((x) => SubCategory.fromJson(x))),
        id: json["Id"],
        pictureId: json["PictureId"],
        imageUrl: json["ImageUrl"],
        categoryName: json["CategoryName"],
        categoryNameH: json["CategoryNameH"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "SubCategories":
            List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "Id": id,
        "PictureId": pictureId,
        "ImageUrl": imageUrl,
        "CategoryName": categoryName,
        "CategoryNameH": categoryNameH,
        "CustomProperties": customProperties!.toJson(),
      };
}

class SubCategory {
  SubCategory({
    required this.id,
    required this.pictureId,
    required this.parentCategoryId,
    required this.productAttributeId,
    required this.glamzSubCategoryId,
    required this.imageUrl,
    required this.subCategoryName,
    required this.subCategoryNameH,
    required this.customProperties,
  });

  int id;
  int pictureId;
  int parentCategoryId;
  int productAttributeId;
  int glamzSubCategoryId;
  String imageUrl;
  String subCategoryName;
  String subCategoryNameH;
  Custom customProperties;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["Id"],
        pictureId: json["PictureId"],
        parentCategoryId: json["ParentCategoryId"],
        productAttributeId: json["ProductAttributeId"],
        glamzSubCategoryId: json["GlamzSubCategoryId"],
        imageUrl: json["ImageUrl"],
        subCategoryName: json["SubCategoryName"],
        subCategoryNameH: json["SubCategoryNameH"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PictureId": pictureId,
        "ParentCategoryId": parentCategoryId,
        "ProductAttributeId": productAttributeId,
        "GlamzSubCategoryId": glamzSubCategoryId,
        "ImageUrl": imageUrl,
        "SubCategoryName": subCategoryName,
        "SubCategoryNameH": subCategoryNameH,
        "CustomProperties": customProperties.toJson(),
      };
}

class Photo {
  Photo({
    required this.pictureId,
    required this.productPictureMappingId,
    required this.imageUrl,
    required this.customProperties,
  });

  int pictureId;
  int productPictureMappingId;
  String imageUrl;
  Custom customProperties;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        pictureId: json["PictureId"],
        productPictureMappingId: json["ProductPictureMappingId"],
        imageUrl: json["ImageUrl"] ?? '',
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "PictureId": pictureId,
        "ProductPictureMappingId": productPictureMappingId,
        "ImageUrl": imageUrl,
        "CustomProperties": customProperties.toJson(),
      };
}

class Review {
  Review({
    this.id,
    this.clientName,
    this.reviewText,
    this.reviewTextE,
    this.rating,
    this.customProperties,
  });

  int? id;
  String? clientName;
  String? reviewText;
  String? reviewTextE;
  int? rating;
  Custom? customProperties;
  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["Id"],
        clientName: json["ClientName"],
        reviewText: json["ReviewText"],
        reviewTextE: json["ReviewTextE"],
        rating: json["Rating"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ClientName": clientName,
        "ReviewText": reviewText,
        "ReviewTextE": reviewTextE,
        "Rating": rating,
        "CustomProperties": customProperties!.toJson(),
      };
}

class SalonDetail {
  SalonDetail({
    this.salonId,
    this.businessId,
    this.name,
    this.nameE,
    this.imageUrl,
    this.shortDescription,
    this.shortDescriptionE,
    this.address,
    this.addressE,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.cart,
    this.price,
    this.rating,
    this.customProperties,
  });

  int? salonId;
  int? businessId;
  String? name;
  String? nameE;
  String? imageUrl;
  String? shortDescription;
  String? shortDescriptionE;
  String? address;
  String? addressE;
  double latitude;
  double longitude;
  double distance;
  int? cart;
  double? price;
  // ignore: unnecessary_question_mark
  dynamic? rating;
  Custom? customProperties;

  factory SalonDetail.fromJson(Map<String, dynamic> json) => SalonDetail(
        salonId: json["SalonId"],
        businessId: json["BusinessId"],
        name: json["Name"],
        nameE: json["NameE"],
        imageUrl: json["ImageUrl"],
        shortDescription: json["ShortDescription"],
        shortDescriptionE: json["ShortDescriptionE"],
        address: json["Address"],
        addressE: json["AddressE"],
        latitude: json["latitude"].toDouble() ?? 0.0,
        longitude: json["longitude"].toDouble() ?? 0.0,
        distance: json["Distance"].toDouble() ?? 0.0,
        cart: json["Cart"],
        price: json["Price"],
        rating: json["Rating"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "SalonId": salonId,
        "BusinessId": businessId,
        "Name": name,
        "NameE": nameE,
        "ImageUrl": imageUrl,
        "ShortDescription": shortDescription,
        "ShortDescriptionE": shortDescriptionE,
        "Address": address,
        "AddressE": addressE,
        "latitude": latitude,
        "longitude": longitude,
        "Cart": cart,
        "Price": price,
        "Rating": rating,
        "CustomProperties": customProperties!.toJson(),
      };
}

class StaffDetail {
  StaffDetail({
    required this.staffId,
    required this.firstName,
    this.lastName,
    required this.position,
    this.imageUrl,
    this.mobile,
    this.alterText,
    required this.customProperties,
  });

  int staffId;
  String firstName;
  dynamic lastName;
  dynamic position;
  dynamic imageUrl;
  String? mobile;
  dynamic alterText;
  Custom customProperties;

  factory StaffDetail.fromJson(Map<String, dynamic> json) => StaffDetail(
        staffId: json["StaffId"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        position: json["Position"],
        imageUrl: json["ImageUrl"],
        mobile: json["Mobile"],
        alterText: json["AlterText"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "StaffId": staffId,
        "FirstName": firstName,
        "LastName": lastName,
        "Position": position,
        "ImageUrl": imageUrl,
        "Mobile": mobile,
        "AlterText": alterText,
        "CustomProperties": customProperties.toJson(),
      };
}

class FacilityType {
  FacilityType({
    required this.id,
    required this.name,
    required this.nameH,
    required this.customProperties,
  });

  int id;
  String name;
  String nameH;
  Custom customProperties;

  factory FacilityType.fromJson(Map<String, dynamic> json) => FacilityType(
        id: json["Id"],
        name: json["Name"],
        nameH: json["NameH"],
        customProperties: Custom.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "NameH": nameH,
        "CustomProperties": customProperties.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

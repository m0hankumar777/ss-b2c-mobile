import 'dart:convert';

List<ServicesModel> servicesModelFromJson(String str) =>
    List<ServicesModel>.from(
        json.decode(str).map((x) => ServicesModel.fromJson(x)));

String servicesModelToJson(List<ServicesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicesModel {
  ServicesModel({
   required this.businessServiceId,
   required this.serviceId,
   required this.businessId,
   required this.categoryId,
   required this.subCategoryId,
    this.categoryName,
    this.subCategoryName,
   required this.serviceName,
    this.categoryNameH,
    this.subCategoryNameH,
 required   this.serviceNameH,
    this.discount,
    this.description,
    this.defaultPrice,
    this.duration,
    this.durationH,
    this.serviceDurationId,
    this.hour,
    this.minute,
    this.isSubService,
    this.subservice,
  });

  int businessServiceId;
  int serviceId;
  int businessId;
  int categoryId;
  int subCategoryId;
  dynamic categoryName;
  dynamic subCategoryName;
  String serviceName;
  dynamic categoryNameH;
  dynamic subCategoryNameH;
  String serviceNameH;
  dynamic discount;
  String? description;
  dynamic defaultPrice;
  String? duration;
  String? durationH;
  int? serviceDurationId;
  int? hour;
  int? minute;
  bool? isSubService;
  List<Subservice>? subservice;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        businessServiceId: json["businessServiceId"],
        serviceId: json["serviceId"],
        businessId: json["businessId"],
        categoryId: json["categoryId"],
        subCategoryId: json["subCategoryId"],
        categoryName: json["categoryName"],
        subCategoryName: json["subCategoryName"],
        serviceName: json["serviceName"],
        categoryNameH: json["categoryNameH"],
        subCategoryNameH: json["subCategoryNameH"],
        serviceNameH: json["serviceNameH"],
        discount: json["discount"],
        description: json["description"],
        defaultPrice: json["defaultPrice"],
        duration: json["duration"],
        durationH: json["durationH"],
        serviceDurationId: json["serviceDurationId"],
        hour: json["hour"],
        minute: json["minute"],
        isSubService: json["isSubService"],
        subservice: List<Subservice>.from(
            json["subservicelist"].map((x) => Subservice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "businessServiceId": businessServiceId,
        "serviceId": serviceId,
        "businessId": businessId,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "categoryName": categoryName,
        "subCategoryName": subCategoryName,
        "serviceName": serviceName,
        "categoryNameH": categoryNameH,
        "subCategoryNameH": subCategoryNameH,
        "serviceNameH": serviceNameH,
        "discount": discount,
        "description": description,
        "defaultPrice": defaultPrice,
        "duration": duration,
        "durationH": durationH,
        "serviceDurationId": serviceDurationId,
        "hour": hour,
        "minute": minute,
        "isSubService": isSubService,
        "subservicelist": List<dynamic>.from(subservice!.map((x) => x.toJson())),
      };
}

class Subservice {
  Subservice({
   required this.subServiceId,
   required this.businessId,
   required this.businessServiceId,
    this.name,
    this.defaultPrice,
    this.duration,
    this.durationH,
    this.hour,
    this.minute,
  });

  int subServiceId;
  int businessId;
  int businessServiceId;
  String? name;
  dynamic defaultPrice;
  String? duration;
  String? durationH;
  int? hour;
  int? minute;

  factory Subservice.fromJson(Map<String, dynamic> json) => Subservice(
        subServiceId: json["subServiceId"],
        businessId: json["businessId"],
        businessServiceId: json["businessServiceId"],
        name: json["name"],
        defaultPrice: json["defaultPrice"],
        duration: json["duration"],
        durationH: json["durationH"],
        hour: json["hour"],
        minute: json["minute"],
      );

  Map<String, dynamic> toJson() => {
        "subServiceId": subServiceId,
        "businessId": businessId,
        "businessServiceId": businessServiceId,
        "name": name,
        "defaultPrice": defaultPrice,
        "duration": duration,
        "durationH": durationH,
        "hour": hour,
        "minute": minute,
      };
}

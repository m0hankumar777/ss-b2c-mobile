// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

List<SubCategoryModel> subCategoryModelFromJson(String str) => List<SubCategoryModel>.from(json.decode(str).map((x) => SubCategoryModel.fromJson(x)));



class SubCategoryModel {
    int subCategoryId;
    String subCategoryNameH;
    String subCategoryName;
    dynamic businessServiceId;
    List<ServiceList> serviceList;

    SubCategoryModel({
        required this.subCategoryId,
        required this.subCategoryNameH,
        required this.subCategoryName,
        this.businessServiceId,
        required this.serviceList,
    });

    factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        subCategoryId: json["SubCategoryId"],
        subCategoryNameH: json["SubCategoryNameH"],
        subCategoryName: json["SubCategoryName"],
        businessServiceId: json["BusinessServiceId"],
        serviceList: List<ServiceList>.from(json["ServiceList"].map((x) => ServiceList.fromJson(x))),
    );


}

class ServiceList {
    int serviceId;
    int businessServiceId;
    String serviceName;
    String serviceNameH;
    String? duration;
    String? durationH;
    num price;
    List<SubServiceList> subServiceList;

    ServiceList({
        required this.serviceId,
        required this.businessServiceId,
        required this.serviceName,
        required this.serviceNameH,
        this.duration,
        this.durationH,
        required this.price,
        required this.subServiceList,
    });

    factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        serviceId: json["ServiceId"],
        businessServiceId: json["BusinessServiceId"],
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
        duration: json["Duration"],
        durationH: json["DurationH"],
        price: json["price"],
        subServiceList:json["SubServiceList"]==null?json["SubServiceList"]: List<SubServiceList>.from(json["SubServiceList"].map((x) => SubServiceList.fromJson(x))),
    );

   
}

class SubServiceList {
    int subServiceId;
    String subServiceName;
    String? duration;
    String? durationH;
    num price;

    SubServiceList({
        required this.subServiceId,
        required this.subServiceName,
        required this.duration,
        required this.durationH,
        required this.price,
    });

    factory SubServiceList.fromJson(Map<String, dynamic> json) => SubServiceList(
        subServiceId: json["SubServiceId"],
        subServiceName: json["SubServiceName"],
        duration: json["Duration"],
        durationH: json["DurationH"],
        price: json["price"],
    );

 
}

// To parse this JSON data, do
//
//     final searchProductModel = searchProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:B2C/model/Home/home_recommendedsalons_model.dart';

List<SearchProductModel> searchProductModelFromJson(String str) =>
    List<SearchProductModel>.from(
        json.decode(str).map((x) => SearchProductModel.fromJson(x)));

String searchProductModelToJson(List<SearchProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchProductModel {
  SearchProductModel({
    required this.totalCount,
    required this.isSearchRatedPlan,
    required this.productId,
    required this.addressH,
    required this.address,
    required this.nameH,
    required this.name,
    this.shortDescription,
    this.shortDescriptionH,
    this.fullDescription,
    this.logoImageUrl,
    this.latitude,
    this.longitude,
    required this.rating,
    this.status,
    this.coverLogo1,
    this.coverLogo2,
    this.coverLogo3,
    this.coverLogo4,
    this.coverLogo5,
    this.fromWorkinghrs,
    this.toWorkinghrs,
    this.tagDetail,
    this.tagDetailH,
    this.distance,
    required this.services,
  });
  int totalCount;
  bool isSearchRatedPlan;
  int productId;
  String addressH;
  String address;
  String nameH;
  String name;
  dynamic shortDescription;
  dynamic shortDescriptionH;
  dynamic fullDescription;
  dynamic logoImageUrl;
  dynamic latitude;
  dynamic longitude;
  dynamic rating;
  dynamic status;
  dynamic coverLogo1;
  dynamic coverLogo2;
  dynamic coverLogo3;
  dynamic coverLogo4;
  dynamic coverLogo5;
  dynamic fromWorkinghrs;
  dynamic toWorkinghrs;
  dynamic tagDetail;
  dynamic tagDetailH;
  dynamic distance;
  List<Service> services;

  factory SearchProductModel.fromJson(Map<String, dynamic> json) =>
      SearchProductModel(
        totalCount: json["TotalCount"],
        isSearchRatedPlan: json["isSearchRatedPlan"],
        productId: json["ProductId"],
        addressH: json["AddressH"],
        address: json["Address"],
        nameH: json["NameH"],
        name: json["Name"],
        shortDescription: json["ShortDescription"] ?? "",
        shortDescriptionH: json["ShortDescriptionH"] ?? "",
        fullDescription: json["fullDescription"] ?? "",
        logoImageUrl: json["LogoImageUrl"] ?? "",
        latitude: json["Latitude"].toDouble() ?? 0.000000,
        longitude: json["Longitude"].toDouble() ?? 0.000000,
        rating: json["Rating"],
        status: json["Status"] ?? "",
        coverLogo1: json["CoverLogo1"] ?? "",
        coverLogo2: json["CoverLogo2"] ?? "",
        coverLogo3: json["CoverLogo3"] ?? "",
        coverLogo4: json["CoverLogo4"] ?? "",
        coverLogo5: json["CoverLogo5"] ?? "",
        fromWorkinghrs: json["FromWorkinghrs"] ?? "",
        toWorkinghrs: json["ToWorkinghrs"] ?? "",
        tagDetail: json["TagDetail"] ?? "",
        tagDetailH: json["TagDetailH"] ?? "",
        distance: json["Distance"] ?? 0,
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TotalCount": totalCount,
        "isSearchRatedPlan": isSearchRatedPlan,
        "ProductId": productId,
        "AddressH": addressH,
        "Address": address,
        "NameH": nameH,
        "Name": name,
        "ShortDescription": shortDescription ?? "",
        "ShortDescriptionH": shortDescriptionH ?? "",
        "fullDescription": fullDescription ?? "",
        "LogoImageUrl": logoImageUrl,
        "Latitude": latitude,
        "Longitude": longitude,
        "Rating": rating,
        "Status": status,
        "CoverLogo1": coverLogo1,
        "CoverLogo2": coverLogo2,
        "CoverLogo3": coverLogo3,
        "CoverLogo4": coverLogo4,
        "CoverLogo5": coverLogo5,
        "FromWorkinghrs": fromWorkinghrs,
        "ToWorkinghrs": toWorkinghrs,
        "TagDetail": tagDetail,
        "TagDetailH": tagDetailH,
        "Distance": distance,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

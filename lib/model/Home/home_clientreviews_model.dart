// To parse this JSON data, do
//
//     final clientReviewsModel = clientReviewsModelFromJson(jsonString);

import 'dart:convert';

List<ClientReviewsModel> clientReviewsModelFromJson(String str) =>
    List<ClientReviewsModel>.from(
        json.decode(str).map((x) => ClientReviewsModel.fromJson(x)));

String clientReviewsModelToJson(List<ClientReviewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClientReviewsModel {
  ClientReviewsModel({
    required this.customerId,
    this.customerAvatarUrl,
    required this.customerName,
    required this.allowViewingProfiles,
    this.title,
    required this.reviewText,
    this.reviewTextE,
    this.replyText,
    required this.rating,
    this.writtenOnStr,
    this.helpfulness,
    required this.additionalProductReviewList,
    required this.salonName,
    required this.salonNameE,
    required this.address,
    required this.addressE,
    required this.imageUrl,
    required this.publishedDate,
    required this.id,
    required this.customProperties,
  });

  int customerId;
  dynamic customerAvatarUrl;
  String customerName;
  bool allowViewingProfiles;
  dynamic title;
  String reviewText;
  dynamic reviewTextE;
  dynamic replyText;
  int rating;
  dynamic writtenOnStr;
  dynamic helpfulness;
  List<dynamic> additionalProductReviewList;
  String salonName;
  String salonNameE;
  String address;
  String addressE;
  String imageUrl;
  DateTime publishedDate;
  int id;
  CustomProperties customProperties;

  factory ClientReviewsModel.fromJson(Map<String, dynamic> json) =>
      ClientReviewsModel(
        customerId: json["CustomerId"],
        customerAvatarUrl: json["CustomerAvatarUrl"],
        customerName: json["CustomerName"] ?? "",
        allowViewingProfiles: json["AllowViewingProfiles"],
        title: json["Title"],
        reviewText: json["ReviewText"] ?? "",
        reviewTextE: json["ReviewTextE"],
        replyText: json["ReplyText"],
        rating: json["Rating"],
        writtenOnStr: json["WrittenOnStr"],
        helpfulness: json["Helpfulness"],
        additionalProductReviewList: List<dynamic>.from(
            json["AdditionalProductReviewList"].map((x) => x)),
        salonName: json["SalonName"],
        salonNameE: json["SalonNameE"],
        address: json["Address"],
        addressE: json["AddressE"],
        imageUrl: json["ImageUrl"] ?? "",
        publishedDate: DateTime.parse(json["PublishedDate"]),
        id: json["Id"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomerId": customerId,
        "CustomerAvatarUrl": customerAvatarUrl,
        "CustomerName": customerName,
        "AllowViewingProfiles": allowViewingProfiles,
        "Title": title,
        "ReviewText": reviewText,
        "ReviewTextE": reviewTextE,
        "ReplyText": replyText,
        "Rating": rating,
        "WrittenOnStr": writtenOnStr,
        "Helpfulness": helpfulness,
        "AdditionalProductReviewList":
            List<dynamic>.from(additionalProductReviewList.map((x) => x)),
        "SalonName": salonName,
        "SalonNameE": salonNameE,
        "Address": address,
        "AddressE": addressE,
        "ImageUrl": imageUrl,
        "PublishedDate": publishedDate.toIso8601String(),
        "Id": id,
        "CustomProperties": customProperties.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

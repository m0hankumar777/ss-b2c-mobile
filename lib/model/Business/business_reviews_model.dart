// To parse this JSON data, do
//
//     final businessReviewsModel = businessReviewsModelFromJson(jsonString);

import 'dart:convert';

List<BusinessReviewsModel> businessReviewsModelFromJson(String str) =>
    List<BusinessReviewsModel>.from(
        json.decode(str).map((x) => BusinessReviewsModel.fromJson(x)));

String businessReviewsModelToJson(List<BusinessReviewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessReviewsModel {
  BusinessReviewsModel({
    this.id,
    this.businessId,
    this.customerId,
    this.clientName,
    this.firstName,
    this.reviewText,
    this.reviewTextE,
    this.replyText,
    this.rating,
    this.publishedDate,
    this.imageUrl,
    this.pictureId,
    this.customProperties,
  });

  int? id;
  int? businessId;
  int? customerId;
  // ignore: unnecessary_question_mark
  dynamic? clientName;
  dynamic firstName;
  String? reviewText;
  String? reviewTextE;
  String? replyText;
  int? rating;
  DateTime? publishedDate;
  String? imageUrl;
  int? pictureId;
  CustomProperties? customProperties;

  factory BusinessReviewsModel.fromJson(Map<String, dynamic> json) =>
      BusinessReviewsModel(
        id: json["Id"],
        businessId: json["BusinessId"],
        customerId: json["CustomerId"],
        clientName: json["ClientName"],
        firstName: json["FirstName"],
        reviewText: json["ReviewText"],
        reviewTextE: json["ReviewTextE"],
        replyText: json["ReplyText"],
        rating: json["Rating"],
        publishedDate: DateTime.parse(json["PublishedDate"]),
        imageUrl: json["ImageUrl"],
        pictureId: json["PictureId"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "BusinessId": businessId,
        "CustomerId": customerId,
        "ClientName": clientName,
        "FirstName": firstName,
        "ReviewText": reviewText,
        "ReviewTextE": reviewTextE,
        "ReplyText": replyText,
        "Rating": rating,
        "PublishedDate": publishedDate!.toIso8601String(),
        "ImageUrl": imageUrl,
        "PictureId": pictureId,
        "CustomProperties": customProperties!.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

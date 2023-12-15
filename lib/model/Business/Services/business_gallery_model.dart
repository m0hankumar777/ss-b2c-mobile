// To parse this JSON data, do
//
//     final gallaryModel = gallaryModelFromJson(jsonString);

import 'dart:convert';

List<GallaryModel> gallaryModelFromJson(String str) => List<GallaryModel>.from(
    json.decode(str).map((x) => GallaryModel.fromJson(x)));

String gallaryModelToJson(List<GallaryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GallaryModel {
  GallaryModel({
    this.pictureId,
    this.productPictureMappingId,
    this.imageUrl,
    this.categoryId,
    this.customProperties,
  });

  int? pictureId;
  int? productPictureMappingId;
  String? imageUrl;
  int? categoryId;
  CustomProperties? customProperties;

  factory GallaryModel.fromJson(Map<String, dynamic> json) => GallaryModel(
        pictureId: json["PictureId"],
        productPictureMappingId: json["ProductPictureMappingId"],
        imageUrl: json["ImageUrl"],
        categoryId: json["CategoryId"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "PictureId": pictureId,
        "ProductPictureMappingId": productPictureMappingId,
        "ImageUrl": imageUrl,
        "CategoryId": categoryId,
        "CustomProperties": customProperties?.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

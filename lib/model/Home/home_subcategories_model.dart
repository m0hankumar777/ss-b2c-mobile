// To parse this JSON data, do
//
//     final subCategoriesModel = subCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<SubCategoriesModel> subCategoriesModelFromJson(String str) =>
    List<SubCategoriesModel>.from(
        json.decode(str).map((x) => SubCategoriesModel.fromJson(x)));

String subCategoriesModelToJson(List<SubCategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategoriesModel {
  SubCategoriesModel({
    required this.id,
    required this.name,
    this.categoryNameH,
    required this.imageUrl,
    required this.b2CImageUrl,
  });

  int id;
  String name;
  dynamic categoryNameH;
  String imageUrl;
  String b2CImageUrl;

  factory SubCategoriesModel.fromJson(Map<String, dynamic> json) =>
      SubCategoriesModel(
        id: json["Id"],
        name: json["Name"],
        categoryNameH: json["CategoryNameH"],
        imageUrl: json["ImageUrl"],
        b2CImageUrl: json["B2CImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "CategoryNameH": categoryNameH,
        "ImageUrl": imageUrl,
        "B2CImageUrl": b2CImageUrl,
      };
}

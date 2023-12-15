// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesModel> categoriesModelFromJson(String str) =>
    List<CategoriesModel>.from(
        json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  CategoriesModel({
    required this.id,
    required this.name,
    required this.categoryNameH,
    required this.imageUrl,
    required this.b2CImageUrl,
  });

  int id;
  String name;
  String categoryNameH;
  String imageUrl;
  String b2CImageUrl;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
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

// To parse this JSON data, do
//
//     final businessFaqModel = businessFaqModelFromJson(jsonString);

import 'dart:convert';

List<BusinessFaqModel> businessFaqModelFromJson(String str) =>
    List<BusinessFaqModel>.from(
        json.decode(str).map((x) => BusinessFaqModel.fromJson(x)));

String businessFaqModelToJson(List<BusinessFaqModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusinessFaqModel {
  BusinessFaqModel({
    required this.id,
    required this.bussinessId,
    required this.categoryId,
    required this.questions,
    required this.answers,
  });

  int id;
  int bussinessId;
  int categoryId;
  String questions;
  String answers;

  factory BusinessFaqModel.fromJson(Map<String, dynamic> json) =>
      BusinessFaqModel(
        id: json["Id"],
        bussinessId: json["BussinessId"],
        categoryId: json["CategoryId"],
        questions: json["Questions"],
        answers: json["Answers"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "BussinessId": bussinessId,
        "CategoryId": categoryId,
        "Questions": questions,
        "Answers": answers,
      };
}

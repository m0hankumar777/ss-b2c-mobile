// To parse this JSON data, do
//
//     final staffModel = staffModelFromJson(jsonString);

import 'dart:convert';

List<StaffModel> staffModelFromJson(String str) =>
    List<StaffModel>.from(json.decode(str).map((x) => StaffModel.fromJson(x)));

class StaffModel {
  StaffModel({
    required this.staffId,
    required this.firstName,
    this.lastName,
    required this.position,
    this.imageUrl,
    required this.mobile,
    this.alterText,
    required this.customProperties,
  });

  int staffId;
  String firstName;
  String? lastName;
  String? position;
  String? imageUrl;
  String mobile;
  String? alterText;
  Map customProperties;

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        staffId: json["StaffId"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        position: json["Position"],
        imageUrl: json["ImageUrl"],
        mobile: json["Mobile"],
        alterText: json["AlterText"],
        customProperties: json["CustomProperties"],
      );
}

// To parse this JSON data, do
//
//     final promoCodeModel = promoCodeModelFromJson(jsonString);

import 'dart:convert';

List<PromoCodeModel> promoCodeModelFromJson(String str) =>
    List<PromoCodeModel>.from(
        json.decode(str).map((x) => PromoCodeModel.fromJson(x)));

class PromoCodeModel {
  bool isActive;
  dynamic createdBy;
  DateTime createdOn;
  dynamic editedBy;
  dynamic editedOn;
  String? phoneNumber;
  String promoCode;
  num discountAmount;
  int minimumOrder;
  DateTime validFrom;
  DateTime expiredAt;
  String? description;
  int clientId;
  int id;

  PromoCodeModel({
    required this.isActive,
    this.createdBy,
    required this.createdOn,
    this.editedBy,
    this.editedOn,
     this.phoneNumber,
    required this.promoCode,
    required this.discountAmount,
    required this.minimumOrder,
    required this.validFrom,
    required this.expiredAt,
    this.description,
    required this.clientId,
    required this.id,
  });

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) => PromoCodeModel(
        isActive: json["IsActive"],
        createdBy: json["CreatedBy"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        editedBy: json["EditedBy"],
        editedOn: json["EditedOn"],
        phoneNumber: json["PhoneNumber"],
        promoCode: json["PromoCode"],
        discountAmount: json["DiscountAmount"],
        minimumOrder: json["MinimumOrder"],
        validFrom: DateTime.parse(json["ValidFrom"]),
        expiredAt: DateTime.parse(json["ExpiredAt"]),
        description: json["Description"],
        clientId: json["ClientId"],
        id: json["Id"],
      );
}

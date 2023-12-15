// To parse this JSON data, do
//
//     final paymentDetailsModel = paymentDetailsModelFromJson(jsonString);

import 'dart:convert';

PaymentDetailsModel paymentDetailsModelFromJson(String str) =>
    PaymentDetailsModel.fromJson(json.decode(str));

String paymentDetailsModelToJson(PaymentDetailsModel data) =>
    json.encode(data.toJson());

class PaymentDetailsModel {
  bool? isActive;
  int? createdBy;
  DateTime? createdOn;
  dynamic editedBy;
  dynamic editedOn;
  String? userId;
  int? businessId;
  int? clientId;
  int? transId;
  String? encTokenVal;
  int? tmonth;
  int? tyear;
  int? status;
  int? l4Digit;
  int? id;

  PaymentDetailsModel({
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.editedBy,
    this.editedOn,
    this.userId,
    this.businessId,
    this.clientId,
    this.transId,
    this.encTokenVal,
    this.tmonth,
    this.tyear,
    this.status,
    this.l4Digit,
    this.id,
  });

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      PaymentDetailsModel(
        isActive: json["IsActive"],
        createdBy: json["CreatedBy"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        editedBy: json["EditedBy"],
        editedOn: json["EditedOn"],
        userId: json["UserId"],
        businessId: json["BusinessId"],
        clientId: json["ClientId"],
        transId: json["TransId"],
        encTokenVal: json["encTokenVal"],
        tmonth: json["Tmonth"],
        tyear: json["Tyear"],
        status: json["Status"],
        l4Digit: json["L4digit"],
        id: json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "IsActive": isActive,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "EditedBy": editedBy,
        "EditedOn": editedOn,
        "UserId": userId,
        "BusinessId": businessId,
        "ClientId": clientId,
        "TransId": transId,
        "encTokenVal": encTokenVal,
        "Tmonth": tmonth,
        "Tyear": tyear,
        "Status": status,
        "L4digit": l4Digit,
        "Id": id,
      };
}

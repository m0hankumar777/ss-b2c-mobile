// To parse this JSON data, do
//
//     final bestRAtedSalonsModel = bestRAtedSalonsModelFromJson(jsonString);

import 'dart:convert';

List<BestRatedSalonsModel> bestRAtedSalonsModelFromJson(String str) =>
    List<BestRatedSalonsModel>.from(
        json.decode(str).map((x) => BestRatedSalonsModel.fromJson(x)));

String bestRAtedSalonsModelToJson(List<BestRatedSalonsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BestRatedSalonsModel {
  BestRatedSalonsModel({
    required this.parentGroupedProductId,
    required this.glamzBusinessId,
    required this.address,
    this.addressE,
    required this.isBestRatedPlan,
    required this.isSearchRatedPlan,
    required this.logoImageUrl,
    required this.name,
    required this.nameE,
    required this.allowCustomerReviews,
    required this.approvedRatingSum,
    required this.notApprovedRatingSum,
    required this.approvedTotalReviews,
    required this.notApprovedTotalReviews,
    required this.isActive,
    required this.createdOn,
    this.editedBy,
    this.editedOn,
    required this.createdBy,
    required this.editedOnUtc,
    required this.businessId,
    required this.day,
    required this.isDayActive,
    required this.fromWorkingHours,
    required this.toWorkingHours,
    required this.fromOptionalWorkingHours,
    required this.toOptionalWorkingHours,
    required this.oldWorkingHoursId,
    required this.oldBusinessId,
  });

  int parentGroupedProductId;
  int glamzBusinessId;
  String address;
  dynamic addressE;
  bool isBestRatedPlan;
  bool isSearchRatedPlan;
  String logoImageUrl;
  String name;
  String nameE;
  bool allowCustomerReviews;
  int approvedRatingSum;
  int notApprovedRatingSum;
  int approvedTotalReviews;
  int notApprovedTotalReviews;
  bool isActive;
  DateTime createdOn;
  dynamic editedBy;
  dynamic editedOn;
  int createdBy;
  DateTime editedOnUtc;
  int businessId;
  int day;
  bool isDayActive;
  String fromWorkingHours;
  String toWorkingHours;
  String fromOptionalWorkingHours;
  String toOptionalWorkingHours;
  int oldWorkingHoursId;
  int oldBusinessId;

  factory BestRatedSalonsModel.fromJson(Map<String, dynamic> json) =>
      BestRatedSalonsModel(
        parentGroupedProductId: json["ParentGroupedProductId"],
        glamzBusinessId: json["GlamzBusinessId"],
        address: json["Address"],
        addressE: json["AddressE"],
        isBestRatedPlan: json["IsBestRatedPlan"],
        isSearchRatedPlan: json["IsSearchRatedPlan"],
        logoImageUrl:
            // ignore: prefer_if_null_operators
            json["LogoImageUrl"] == null ? null : json["LogoImageUrl"],
        name: json["Name"],
        // ignore: prefer_if_null_operators
        nameE: json["NameE"] == null ? null : json["NameE"],
        allowCustomerReviews: json["AllowCustomerReviews"],
        approvedRatingSum: json["ApprovedRatingSum"],
        notApprovedRatingSum: json["NotApprovedRatingSum"],
        approvedTotalReviews: json["ApprovedTotalReviews"],
        notApprovedTotalReviews: json["NotApprovedTotalReviews"],
        isActive: json["IsActive"],
        createdOn: DateTime.parse(json["CreatedOn"]),
        editedBy: json["EditedBy"],
        editedOn: json["EditedOn"],
        createdBy: json["CreatedBy"],
        editedOnUtc: DateTime.parse(json["EditedOnUtc"]),
        businessId: json["BusinessId"],
        day: json["Day"],
        isDayActive: json["IsDayActive"],
        fromWorkingHours: json["FromWorkingHours"],
        toWorkingHours: json["ToWorkingHours"],
        fromOptionalWorkingHours: json["FromOptionalWorkingHours"],
        toOptionalWorkingHours: json["ToOptionalWorkingHours"],
        oldWorkingHoursId: json["OldWorkingHoursId"],
        oldBusinessId: json["OldBusinessId"],
      );

  Map<String, dynamic> toJson() => {
        "ParentGroupedProductId": parentGroupedProductId,
        "GlamzBusinessId": glamzBusinessId,
        "Address": address,
        "AddressE": addressE,
        "IsBestRatedPlan": isBestRatedPlan,
        "IsSearchRatedPlan": isSearchRatedPlan,
        // ignore: prefer_if_null_operators, unnecessary_null_comparison
        "LogoImageUrl": logoImageUrl == null ? null : logoImageUrl,
        "Name": name,
        // ignore: prefer_if_null_operators, unnecessary_null_comparison
        "NameE": nameE == null ? null : nameE,
        "AllowCustomerReviews": allowCustomerReviews,
        "ApprovedRatingSum": approvedRatingSum,
        "NotApprovedRatingSum": notApprovedRatingSum,
        "ApprovedTotalReviews": approvedTotalReviews,
        "NotApprovedTotalReviews": notApprovedTotalReviews,
        "IsActive": isActive,
        "CreatedOn": createdOn.toIso8601String(),
        "EditedBy": editedBy,
        "EditedOn": editedOn,
        "CreatedBy": createdBy,
        "EditedOnUtc": editedOnUtc.toIso8601String(),
        "BusinessId": businessId,
        "Day": day,
        "IsDayActive": isDayActive,
        "FromWorkingHours": fromWorkingHours,
        "ToWorkingHours": toWorkingHours,
        "FromOptionalWorkingHours": fromOptionalWorkingHours,
        "ToOptionalWorkingHours": toOptionalWorkingHours,
        "OldWorkingHoursId": oldWorkingHoursId,
        "OldBusinessId": oldBusinessId,
      };
}

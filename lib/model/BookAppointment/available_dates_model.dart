// ignore: file_names
// To parse this JSON data, do
//
//     final availableDatesModel = availableDatesModelFromJson(jsonString);

import 'dart:convert';

List<AvailableDatesModel> availableDatesModelFromJson(String str) =>
    List<AvailableDatesModel>.from(
        json.decode(str).map((x) => AvailableDatesModel.fromJson(x)));

class AvailableDatesModel {
  AvailableDatesModel({
    required this.workinghourslist,
    required this.businessId,
    required this.staffId,
    required this.availableDate,
    required this.month,
    required this.isStaffAvailable,
    this.notAvailableDate,
    required this.availableWeekDay,
    this.isCustomWorkingHours,
    required this.bookingType,
  });

  List<String> workinghourslist;
  int businessId;
  int staffId;
  String availableDate;
  int month;
  bool isStaffAvailable;
  String? notAvailableDate;
  String availableWeekDay;
  String? isCustomWorkingHours;
  int bookingType;

  factory AvailableDatesModel.fromJson(Map<String, dynamic> json) =>
      AvailableDatesModel(
        workinghourslist:
            List<String>.from(json["workinghourslist"].map((x) => x)),
        businessId: json["businessId"],
        staffId: json["staffId"],
        availableDate: json["availableDate"],
        month: json["month"],
        isStaffAvailable: json["isStaffAvailable"],
        notAvailableDate: json["NotAvailableDate"],
        availableWeekDay: json["AvailableWeekDay"],
        isCustomWorkingHours: json["IsCustomWorkingHours"],
        bookingType: json["BookingType"],
      );
}

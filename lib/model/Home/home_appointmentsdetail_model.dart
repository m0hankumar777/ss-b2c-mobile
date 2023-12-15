// To parse this JSON data, do
//
//     final appointmentDetailsModel = appointmentDetailsModelFromJson(jsonString);

import 'dart:convert';

AppointmentDetailsModel appointmentDetailsModelFromJson(String str) =>
    AppointmentDetailsModel.fromJson(json.decode(str));

String appointmentDetailsModelToJson(AppointmentDetailsModel data) =>
    json.encode(data.toJson());

class AppointmentDetailsModel {
  int? businessId;
  int? appointmentId;
  String? appointmentDate;
  String? businessName;
  // ignore: unnecessary_question_mark
  dynamic? businessAddress;
  String? businessAddressE;
  String? profileImage;
  // ignore: unnecessary_question_mark
  dynamic? totalPrice;
  DateTime? appointmentStartTime;
  List<ServList>? servList;

  AppointmentDetailsModel({
    this.businessId,
    this.appointmentId,
    this.appointmentDate,
    this.businessName,
    this.businessAddress,
    this.businessAddressE,
    this.profileImage,
    this.totalPrice,
    this.appointmentStartTime,
    this.servList,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailsModel(
        businessId: json["BusinessId"],
        appointmentId: json["AppointmentId"],
        appointmentDate: json["AppointmentDate"],
        businessName: json["BusinessName"],
        businessAddress: json["BusinessAddress"],
        businessAddressE: json["BusinessAddressE"],
        profileImage: json["ProfileImage"],
        totalPrice: json["TotalPrice"],
        appointmentStartTime: DateTime.parse(json["AppointmentStartTime"]),
        servList: List<ServList>.from(
            json["ServList"].map((x) => ServList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "BusinessId": businessId,
        "AppointmentId": appointmentId,
        "AppointmentDate": appointmentDate,
        "BusinessName": businessName,
        "BusinessAddress": businessAddress,
        "BusinessAddressE": businessAddressE,
        "ProfileImage": profileImage,
        "TotalPrice": totalPrice,
        "AppointmentStartTime": appointmentStartTime!.toIso8601String(),
        "ServList": List<dynamic>.from(servList!.map((x) => x.toJson())),
      };
}

class ServList {
  int serviceId;
  int serviceDurationId;
  int businessServiceId;
  String serviceName;
  dynamic serviceNameH;
  dynamic duration;
  dynamic durationH;
  dynamic price;
  dynamic subServiceList;

  ServList({
    required this.serviceId,
    required this.serviceDurationId,
    required this.businessServiceId,
    required this.serviceName,
    this.serviceNameH,
    this.duration,
    this.durationH,
    required this.price,
    this.subServiceList,
  });

  factory ServList.fromJson(Map<String, dynamic> json) => ServList(
        serviceId: json["ServiceId"],
        serviceDurationId: json["ServiceDurationId"],
        businessServiceId: json["BusinessServiceId"],
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
        duration: json["Duration"],
        durationH: json["DurationH"],
        price: json["price"],
        subServiceList: json["SubServiceList"],
      );

  Map<String, dynamic> toJson() => {
        "ServiceId": serviceId,
        "ServiceDurationId": serviceDurationId,
        "BusinessServiceId": businessServiceId,
        "ServiceName": serviceName,
        "ServiceNameH": serviceNameH,
        "Duration": duration,
        "DurationH": durationH,
        "price": price,
        "SubServiceList": subServiceList,
      };
}

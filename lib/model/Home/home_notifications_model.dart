// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

List<NotificationsModel> notificationsModelFromJson(String str) =>
    List<NotificationsModel>.from(
        json.decode(str).map((x) => NotificationsModel.fromJson(x)));

String notificationsModelToJson(List<NotificationsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationsModel {
  int id;
  int businessId;
  int clientId;
  String message;
  ObjectType? objectType;
  bool read;
  dynamic appointmentId;
  DateTime createdOn;

  NotificationsModel({
    required this.id,
    required this.businessId,
    required this.clientId,
    required this.message,
    this.objectType,
    required this.read,
    required this.appointmentId,
    required this.createdOn,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        id: json["Id"],
        businessId: json["BusinessId"],
        clientId: json["ClientId"],
        message: json["Message"],
        objectType: objectTypeValues.map[json["ObjectType"]],
        read: json["Read"],
        appointmentId: json["AppointmentId"],
        createdOn: DateTime.parse(json["CreatedOn"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "BusinessId": businessId,
        "ClientId": clientId,
        "Message": message,
        "ObjectType": objectTypeValues.reverse[objectType],
        "Read": read,
        "AppointmentId": appointmentId,
        "CreatedOn": createdOn.toIso8601String(),
      };
}

enum ObjectType {
  // ignore: constant_identifier_names
  APPOINTMENT_NOSHOW,
  // ignore: constant_identifier_names
  APPOINTMENT_3_HOURS_LEFT,
  // ignore: constant_identifier_names
  APPOINTMENT_1_DAY_BEFORE
}

final objectTypeValues = EnumValues({
  "Appointment-1Day Before": ObjectType.APPOINTMENT_1_DAY_BEFORE,
  "Appointment-3 Hours Left": ObjectType.APPOINTMENT_3_HOURS_LEFT,
  "Appointment-Noshow": ObjectType.APPOINTMENT_NOSHOW
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

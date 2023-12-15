// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.customerProfileId,
    this.notificationEnabled,
    this.pushNotificationforMob,
  });

  int? customerProfileId;
  bool? notificationEnabled;
  bool? pushNotificationforMob;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        customerProfileId: json["CustomerProfileId"],
        notificationEnabled: json["NotificationEnabled"],
        pushNotificationforMob: json["PushNotificationforMob"],
      );

  Map<String, dynamic> toJson() => {
        "CustomerProfileId": customerProfileId,
        "NotificationEnabled": notificationEnabled,
        "PushNotificationforMob": pushNotificationforMob,
      };
}

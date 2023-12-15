// To parse this JSON data, do
//
//     final recommendedSalonsModel = recommendedSalonsModelFromJson(jsonString);

import 'dart:convert';

List<RecommendedSalonsModel> recommendedSalonsModelFromJson(String str) =>
    List<RecommendedSalonsModel>.from(
        json.decode(str).map((x) => RecommendedSalonsModel.fromJson(x)));

String recommendedSalonsModelToJson(List<RecommendedSalonsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendedSalonsModel {
  RecommendedSalonsModel({
    required this.id,
    required this.name,
    required this.address,
    required this.coverImage,
    required this.profileImage,
    required this.totalrating,
    required this.noofrating,
    required this.fromWorkinghrs,
    required this.toWorkinghrs,
    required this.longitude,
    required this.latitude,
    required this.distance,
    required this.services,
  });

  int id;
  String name;
  String address;
  String coverImage;
  String profileImage;
  double totalrating;
  int noofrating;
  String fromWorkinghrs;
  String toWorkinghrs;
  double longitude;
  double latitude;
  double distance;
  List<Service> services;

  factory RecommendedSalonsModel.fromJson(Map<String, dynamic> json) =>
      RecommendedSalonsModel(
        id: json["Id"],
        name: json["Name"],
        address: json["Address"],
        coverImage: json["CoverImage"],
        profileImage: json["ProfileImage"] ?? '',
        totalrating: json["Totalrating"],
        noofrating: json["Noofrating"],
        fromWorkinghrs: json["FromWorkinghrs"] ?? '',
        toWorkinghrs: json["ToWorkinghrs"] ?? '',
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        distance: json["Distance"]?.toDouble(),
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Address": address,
        "CoverImage": coverImage,
        "ProfileImage": profileImage,
        "Totalrating": totalrating,
        "Noofrating": noofrating,
        "FromWorkinghrs": fromWorkinghrs,
        "ToWorkinghrs": toWorkinghrs,
        "longitude": longitude,
        "latitude": latitude,
        "distance": "distance",
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

class Service {
  Service({
    required this.serviceName,
    required this.serviceNameH,
  });

  String serviceName;
  String serviceNameH;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
      );

  Map<String, dynamic> toJson() => {
        "ServiceName": serviceName,
        "ServiceNameH": serviceNameH,
      };
}

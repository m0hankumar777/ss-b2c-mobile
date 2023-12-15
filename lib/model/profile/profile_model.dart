// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.customerProfileId,
    this.avatarUrl,
    this.locationEnabled,
    this.location,
    this.pmEnabled,
    this.totalPostsEnabled,
    this.totalPosts,
    this.joinDateEnabled,
    this.joinDate,
    this.dateOfBirthEnabled,
    this.dateOfBirth,
    this.dob,
    this.profileName,
    this.profileEmail,
    this.gender,
    this.phoneNumber,
    this.address1,
    this.address2,
    this.city,
    this.country,
    this.postalCode,
    this.firstname,
    this.lastname,
    this.customProperties,
  });

  int? customerProfileId;
  String? avatarUrl;
  bool? locationEnabled;
  String? location;
  bool? pmEnabled;
  bool? totalPostsEnabled;
  String? totalPosts;
  bool? joinDateEnabled;
  String? joinDate;
  bool? dateOfBirthEnabled;
  dynamic dateOfBirth;
  DateTime? dob;
  String? profileName;
  String? profileEmail;
  String? gender;
  String? phoneNumber;
  String? address1;
  String? address2;
  String? city;
  String? country;
  String? postalCode;
  String? firstname;
  String? lastname;
  CustomProperties? customProperties;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        customerProfileId: json["CustomerProfileId"],
        avatarUrl: json["AvatarUrl"],
        locationEnabled: json["LocationEnabled"],
        location: json["Location"],
        pmEnabled: json["PMEnabled"],
        totalPostsEnabled: json["TotalPostsEnabled"],
        totalPosts: json["TotalPosts"],
        joinDateEnabled: json["JoinDateEnabled"],
        joinDate: json["JoinDate"],
        dateOfBirthEnabled: json["DateOfBirthEnabled"],
        dateOfBirth: json["DateOfBirth"],
        dob: DateTime.parse(json["DOB"]),
        profileName: json["ProfileName"],
        profileEmail: json["ProfileEmail"],
        gender: json["Gender"],
        phoneNumber: json["PhoneNumber"],
        address1: json["Address1"],
        address2: json["Address2"],
        city: json["City"],
        country: json["Country"],
        postalCode: json["PostalCode"],
        firstname: json["Firstname"],
        lastname: json["Lastname"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
      );

  Map<String, dynamic> toJson() => {
        "CustomerProfileId": customerProfileId,
        "AvatarUrl": avatarUrl,
        "LocationEnabled": locationEnabled,
        "Location": location,
        "PMEnabled": pmEnabled,
        "TotalPostsEnabled": totalPostsEnabled,
        "TotalPosts": totalPosts,
        "JoinDateEnabled": joinDateEnabled,
        "JoinDate": joinDate,
        "DateOfBirthEnabled": dateOfBirthEnabled,
        "DateOfBirth": dateOfBirth,
        "DOB": dob!.toIso8601String(),
        "ProfileName": profileName,
        "ProfileEmail": profileEmail,
        "Gender": gender,
        "PhoneNumber": phoneNumber,
        "Address1": address1,
        "Address2": address2,
        "City": city,
        "Country": country,
        "PostalCode": postalCode,
        "Firstname": firstname,
        "Lastname": lastname,
        "CustomProperties": customProperties!.toJson(),
      };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties();

  Map<String, dynamic> toJson() => {};
}

// ignore: file_names
import 'dart:convert';
import 'package:hive/hive.dart';
part 'customer_model.g.dart';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    this.token,
    this.issuccess,
    this.errorMessage,
    this.statusCode,
    this.customer,
  });

  String? token;
  bool? issuccess;
  // ignore: unnecessary_question_mark
  dynamic? errorMessage;
  int? statusCode;
  Customer? customer;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        token: json["token"],
        issuccess: json["issuccess"],
        errorMessage: json["errorMessage"],
        statusCode: json["statusCode"],
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "issuccess": issuccess,
        "errorMessage": errorMessage,
        "statusCode": statusCode,
        "customer": customer?.toJson(),
      };
}

@HiveType(typeId: 1)
class Customer {
  Customer({
    this.gender,
    this.dob,
    this.customerGuid,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.emailToRevalidate,
    this.adminComment,
    this.isTaxExempt,
    this.notificationEnabled,
    this.pushNotificationforMob,
    this.affiliateId,
    this.vendorId,
    this.hasShoppingCartItems,
    this.requireReLogin,
    this.failedLoginAttempts,
    this.cannotLoginUntilDateUtc,
    this.active,
    this.deleted,
    this.isSystemAccount,
    this.systemName,
    this.lastIpAddress,
    this.createdOnUtc,
    this.lastLoginDateUtc,
    this.lastActivityDateUtc,
    this.registeredInStoreId,
    this.billingAddressId,
    this.shippingAddressId,
    this.pictureId,
    this.id,
  });

  @HiveField(0)
  String? gender;
  @HiveField(1)
  DateTime? dob;
  @HiveField(2)
  String? customerGuid;
  @HiveField(3)
  String? username;
  @HiveField(4)
  String? firstName;
  @HiveField(5)
  String? lastName;
  @HiveField(6)
  String? email;
  @HiveField(7)
  String? phoneNumber;
  @HiveField(8)
  dynamic emailToRevalidate;
  @HiveField(9)
  dynamic adminComment;
  @HiveField(10)
  bool? isTaxExempt;
  @HiveField(11)
  bool? notificationEnabled;
  @HiveField(12)
  bool? pushNotificationforMob;
  @HiveField(13)
  int? affiliateId;
  @HiveField(14)
  int? vendorId;
  @HiveField(15)
  bool? hasShoppingCartItems;
  @HiveField(16)
  bool? requireReLogin;
  @HiveField(17)
  int? failedLoginAttempts;
  @HiveField(18)
  dynamic cannotLoginUntilDateUtc;
  @HiveField(19)
  bool? active;
  @HiveField(20)
  bool? deleted;
  @HiveField(21)
  bool? isSystemAccount;
  @HiveField(22)
  dynamic systemName;
  @HiveField(23)
  dynamic lastIpAddress;
  @HiveField(24)
  DateTime? createdOnUtc;
  @HiveField(25)
  dynamic lastLoginDateUtc;
  @HiveField(26)
  DateTime? lastActivityDateUtc;
  @HiveField(27)
  int? registeredInStoreId;
  @HiveField(28)
  dynamic billingAddressId;
  @HiveField(29)
  dynamic shippingAddressId;
  @HiveField(30)
  dynamic pictureId;
  @HiveField(31)
  int? id;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        gender: json["Gender"],
        dob: DateTime.parse(json["DOB"]),
        customerGuid: json["CustomerGuid"],
        username: json["Username"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        emailToRevalidate: json["EmailToRevalidate"],
        adminComment: json["AdminComment"],
        isTaxExempt: json["IsTaxExempt"],
        notificationEnabled: json["NotificationEnabled"],
        pushNotificationforMob: json["PushNotificationforMob"],
        affiliateId: json["AffiliateId"],
        vendorId: json["VendorId"],
        hasShoppingCartItems: json["HasShoppingCartItems"],
        requireReLogin: json["RequireReLogin"],
        failedLoginAttempts: json["FailedLoginAttempts"],
        cannotLoginUntilDateUtc: json["CannotLoginUntilDateUtc"],
        active: json["Active"],
        deleted: json["Deleted"],
        isSystemAccount: json["IsSystemAccount"],
        systemName: json["SystemName"],
        lastIpAddress: json["LastIpAddress"],
        createdOnUtc: DateTime.parse(json["CreatedOnUtc"]),
        lastLoginDateUtc: json["LastLoginDateUtc"],
        lastActivityDateUtc: DateTime.parse(json["LastActivityDateUtc"]),
        registeredInStoreId: json["RegisteredInStoreId"],
        billingAddressId: json["BillingAddressId"],
        shippingAddressId: json["ShippingAddressId"],
        pictureId: json["PictureId"],
        id: json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "Gender": gender,
        "DOB": dob?.toIso8601String(),
        "CustomerGuid": customerGuid,
        "Username": username,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "EmailToRevalidate": emailToRevalidate,
        "AdminComment": adminComment,
        "IsTaxExempt": isTaxExempt,
        "NotificationEnabled": notificationEnabled,
        "PushNotificationforMob": pushNotificationforMob,
        "AffiliateId": affiliateId,
        "VendorId": vendorId,
        "HasShoppingCartItems": hasShoppingCartItems,
        "RequireReLogin": requireReLogin,
        "FailedLoginAttempts": failedLoginAttempts,
        "CannotLoginUntilDateUtc": cannotLoginUntilDateUtc,
        "Active": active,
        "Deleted": deleted,
        "IsSystemAccount": isSystemAccount,
        "SystemName": systemName,
        "LastIpAddress": lastIpAddress,
        "CreatedOnUtc": createdOnUtc?.toIso8601String(),
        "LastLoginDateUtc": lastLoginDateUtc,
        "LastActivityDateUtc": lastActivityDateUtc?.toIso8601String(),
        "RegisteredInStoreId": registeredInStoreId,
        "BillingAddressId": billingAddressId,
        "ShippingAddressId": shippingAddressId,
        "PictureId": pictureId,
        "Id": id,
      };
}

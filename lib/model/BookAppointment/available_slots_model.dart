// To parse this JSON data, do
//
//     final availableSlotModel = availableSlotModelFromJson(jsonString);

import 'dart:convert';

List<AvailableSlotModel> availableSlotModelFromJson(String str) =>
    List<AvailableSlotModel>.from(
        json.decode(str).map((x) => AvailableSlotModel.fromJson(x)));

class AvailableSlotModel {
  AvailableSlotModel({
    required this.selectedDate,
    required this.serviceId,
    required this.subServiceId,
    required this.isSubService,
    required this.businessId,
    this.serviceName,
    this.serviceNameH,
    this.subServiceName,
    required this.price,
    required this.workingHoursId,
    required this.staffId,
    required this.fromWorkingHours,
    this.toWorkingHours,
    this.address,
   this.businessName,
  this.businessLogoUrl,
     this.serviceList,
    this.hoursFormat,
     this.bookingValue,
     this.customProperties,
  });

  String selectedDate;
  int serviceId;
  int subServiceId;
  bool isSubService;
  int businessId;
  dynamic serviceName;
  dynamic serviceNameH;
  dynamic subServiceName;
  num price;
  int workingHoursId;
  int staffId;
  String fromWorkingHours;
  dynamic toWorkingHours;
  String? address;
  String? businessName;
  String? businessLogoUrl;
  List<ServicesModel>? serviceList;
  String? hoursFormat;
  int? bookingValue;
  Map? customProperties;

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) =>
      AvailableSlotModel(
        selectedDate: json["SelectedDate"],
        serviceId: json["ServiceId"],
        subServiceId: json["SubServiceId"],
        isSubService: json["IsSubService"],
        businessId: json["BusinessId"],
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
        subServiceName: json["SubServiceName"],
        price: json["Price"],
        workingHoursId: json["WorkingHoursId"],
        staffId: json["StaffId"],
        fromWorkingHours: json["FromWorkingHours"],
        toWorkingHours: json["ToWorkingHours"],
        address: json["Address"],
        businessName: json["BusinessName"],
        businessLogoUrl: json["BusinessLogoUrl"],
        serviceList: List<ServicesModel>.from(
            json["ServiceList"].map((x) => ServicesModel.fromJson(x))),
        hoursFormat: json["HoursFormat"] ?? "",
        bookingValue: json["BookingValue"],
        customProperties: json["CustomProperties"],
      );
}

class ServicesModel {
  ServicesModel({
    required this.serviceId,
    required this.serviceDurationId,
    required this.businessId,
    required this.staffId,
    required this.appointmentSlotId,
    this.appointmentDate,
    required this.serviceName,
    required this.serviceNameH,
    required this.subserviceId,
    required this.subServiceName,
    required this.isSubservice,
    required this.price,
  });

  int serviceId;
  int serviceDurationId;
  int businessId;
  int staffId;
  int appointmentSlotId;
  dynamic appointmentDate;
  String serviceName;
  String serviceNameH;
  int subserviceId;
  String subServiceName;
  bool isSubservice;
  num price;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        serviceId: json["ServiceId"],
        serviceDurationId: json["ServiceDurationId"],
        businessId: json["BusinessId"],
        staffId: json["StaffId"],
        appointmentSlotId: json["AppointmentSlotId"],
        appointmentDate: json["AppointmentDate"],
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
        subserviceId: json["SubserviceId"],
        subServiceName: json["SubServiceName"],
        isSubservice: json["IsSubservice"],
        price: json["Price"],
      );
}

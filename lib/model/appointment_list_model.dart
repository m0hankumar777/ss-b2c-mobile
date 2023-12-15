// ignore: file_names
import 'dart:convert';

PastFutureAppointmentsModel pastFutureAppointmentsModelFromJson(String str) =>
    PastFutureAppointmentsModel.fromJson(json.decode(str));

String pastFutureAppointmentsModelToJson(PastFutureAppointmentsModel data) =>
    json.encode(data.toJson());

class PastFutureAppointmentsModel {
  PastFutureAppointmentsModel({
    this.clientPastAppointments,
    this.clientFutureAppointments,
  });

  List<ClientAppointment>? clientPastAppointments;
  List<ClientAppointment>? clientFutureAppointments;

  factory PastFutureAppointmentsModel.fromJson(Map<String, dynamic> json) =>
      PastFutureAppointmentsModel(
        clientPastAppointments: List<ClientAppointment>.from(
            json["ClientPastAppointments"]
                .map((x) => ClientAppointment.fromJson(x))),
        clientFutureAppointments: List<ClientAppointment>.from(
            json["ClientFutureAppointments"]
                .map((x) => ClientAppointment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ClientPastAppointments":
            List<dynamic>.from(clientPastAppointments!.map((x) => x.toJson())),
        "ClientFutureAppointments": List<dynamic>.from(
            clientFutureAppointments!.map((x) => x.toJson())),
      };
}

class ClientAppointment {
  ClientAppointment({
    required this.clientId,
    required this.appointmentId,
    required this.serviceId,
    required this.staffId,
    required this.businessId,
    required this.appointmentServiceId,
    this.clientName,
    this.staffName,
    required this.startTime,
    this.endTime,
    required this.appointmentDate,
    required this.total,
    required this.appointmentType,
    required this.businessUserName,
    required this.businessUserAddress,
    required this.businessUserMobile,
    required this.status,
    required this.appointmentService,
    this.logo,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  int clientId;
  int appointmentId;
  int serviceId;
  int staffId;
  int businessId;
  int appointmentServiceId;
  String? clientName;
  String? staffName;
  DateTime startTime;
  dynamic endTime;
  DateTime appointmentDate;
  dynamic total;
  int appointmentType;
  String? businessUserName;
  String? businessUserAddress;
  String? businessUserMobile;
  int status;
  List<AppointmentService> appointmentService;
  String? logo;
  dynamic latitude;
  dynamic longitude;
  dynamic distance;

  factory ClientAppointment.fromJson(Map<String, dynamic> json) =>
      ClientAppointment(
        clientId: json["clientId"],
        appointmentId: json["appointmentId"],
        serviceId: json["serviceId"],
        staffId: json["staffId"],
        businessId: json["businessId"],
        appointmentServiceId: json["appointmentServiceId"],
        clientName: json["clientName"],
        staffName: json["staffName"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: json["endTime"],
        appointmentDate: DateTime.parse(json["appointmentDate"]),
        total: json["Total"],
        appointmentType: json["appointmentType"],
        businessUserName: json["businessUserName"],
        businessUserAddress: json["businessUserAddress"],
        businessUserMobile: json["businessUserMobile"],
        status: json["status"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        distance: json["Distance"]?.toDouble(),
        appointmentService: List<AppointmentService>.from(
            json["AppointmentService"]
                .map((x) => AppointmentService.fromJson(x))),
        logo: json["Logo"],
      );

  Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "appointmentId": appointmentId,
        "serviceId": serviceId,
        "staffId": staffId,
        "businessId": businessId,
        "appointmentServiceId": appointmentServiceId,
        "clientName": clientName,
        "staffName": staffName,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime,
        "appointmentDate": appointmentDate.toIso8601String(),
        "Total": total,
        "appointmentType": appointmentType,
        "businessUserName": businessUserName,
        "businessUserAddress": businessUserAddress,
        "businessUserMobile": businessUserMobile,
        "status": status,
        "AppointmentService":
            List<dynamic>.from(appointmentService.map((x) => x.toJson())),
        "Logo": logo,
         "latitude": latitude,
        "longitude": longitude,
        "Distance": distance,
      };
}

class AppointmentService {
  AppointmentService({
    required this.appointmentServiceId,
    required this.appointmentId,
    required this.businessId,
    required this.staffId,
    required this.subServiceId,
    required this.staffName,
    this.subServiceName,
    required this.serviceId,
    required this.businessServiceId,
    required this.serviceName,
    required this.serviceNameH,
    required this.balance,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.appointmentType,
    required this.clientId,
    required this.appointmentDate,
    this.subservicelist,
    required this.isSubService,
    required this.isStaffActive,
    required this.parentAppServId,
    required this.isRepeat,
    this.businessUserName,
    this.businessUserAddress,
    this.businessUserMobile,
    required this.price,
  });

  int appointmentServiceId;
  int appointmentId;
  int businessId;
  int staffId;
  int subServiceId;
  String staffName;
  dynamic subServiceName;
  int serviceId;
  int businessServiceId;
  String serviceName;
  String serviceNameH;
  dynamic balance;
  DateTime startTime;
  DateTime endTime;
  int status;
  int appointmentType;
  int clientId;
  DateTime appointmentDate;
  dynamic subservicelist;
  bool isSubService;
  bool isStaffActive;
  int parentAppServId;
  bool isRepeat;
  dynamic businessUserName;
  dynamic businessUserAddress;
  dynamic businessUserMobile;
  dynamic price;

  factory AppointmentService.fromJson(Map<String, dynamic> json) =>
      AppointmentService(
        appointmentServiceId: json["AppointmentServiceId"],
        appointmentId: json["AppointmentId"],
        businessId: json["BusinessId"],
        staffId: json["StaffId"],
        subServiceId: json["SubServiceId"],
        staffName: json["StaffName"]!,
        subServiceName: json["SubServiceName"],
        serviceId: json["ServiceId"],
        businessServiceId: json["BusinessServiceId"],
        serviceName: json["ServiceName"]!,
        serviceNameH: json["ServiceNameH"]!,
        balance: json["Balance"],
        startTime: DateTime.parse(json["StartTime"]),
        endTime: DateTime.parse(json["EndTime"]),
        status: json["Status"],
        appointmentType: json["AppointmentType"],
        clientId: json["ClientId"],
        appointmentDate: DateTime.parse(json["AppointmentDate"]),
        subservicelist: json["subservicelist"],
        isSubService: json["isSubService"],
        isStaffActive: json["isStaffActive"],
        parentAppServId: json["ParentAppServId"],
        isRepeat: json["IsRepeat"],
        businessUserName: json["businessUserName"],
        businessUserAddress: json["businessUserAddress"],
        businessUserMobile: json["businessUserMobile"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "AppointmentServiceId": appointmentServiceId,
        "AppointmentId": appointmentId,
        "BusinessId": businessId,
        "StaffId": staffId,
        "SubServiceId": subServiceId,
        "StaffName": staffName,
        "SubServiceName": subServiceName,
        "ServiceId": serviceId,
        "BusinessServiceId": businessServiceId,
        "ServiceName": serviceName,
        "ServiceNameH": serviceNameH,
        "Balance": balance,
        "StartTime": startTime.toIso8601String(),
        "EndTime": endTime.toIso8601String(),
        "Status": status,
        "AppointmentType": appointmentType,
        "ClientId": clientId,
        "AppointmentDate": appointmentDate.toIso8601String(),
        "subservicelist": subservicelist,
        "isSubService": isSubService,
        "isStaffActive": isStaffActive,
        "ParentAppServId": parentAppServId,
        "IsRepeat": isRepeat,
        "businessUserName": businessUserName,
        "businessUserAddress": businessUserAddress,
        "businessUserMobile": businessUserMobile,
        "price": price,
      };
}

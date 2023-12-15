import 'dart:convert';

SuccessAppointmentModel successAppointmentModelFromJson(String str) =>
    SuccessAppointmentModel.fromJson(json.decode(str));

class SuccessAppointmentModel {
  bool? isActive;
  dynamic createdBy;
  dynamic createdOn;
  dynamic editedBy;
  dynamic editedOn;
  int? appointmentId;
  int? businessId;
  int? staffId;
  int? categoryId;
  int? subCategoryId;
  num? discount;
  String? address;
  String? addressE;
  int? serviceId;
  int? subServiceId;
  int? businessServiceId;
  num? price;
  num? balance;
  DateTime? serviceDate;
  DateTime? startTime;
  DateTime? endTime;
  int? appointmentTimeSlotId;
  int? serviceDurationId;
  dynamic duration;
  dynamic durationH;
  String? subServiceName;
  bool? isPunchCardAvailable;
  bool? isPunchCardAdded;
  int? status;
  int? clientFamilyId;
  bool? isWaitingList;
  int? parentAppServId;
  bool? isRepeat;
  int? id;

  SuccessAppointmentModel({
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.editedBy,
    this.editedOn,
    this.appointmentId,
    this.businessId,
    this.staffId,
    this.categoryId,
    this.subCategoryId,
    this.discount,
    this.address,
    this.addressE,
    this.serviceId,
    this.subServiceId,
    this.businessServiceId,
    this.price,
    this.balance,
    this.serviceDate,
    this.startTime,
    this.endTime,
    this.appointmentTimeSlotId,
    this.serviceDurationId,
    this.duration,
    this.durationH,
    this.subServiceName,
    this.isPunchCardAvailable,
    this.isPunchCardAdded,
    this.status,
    this.clientFamilyId,
    this.isWaitingList,
    this.parentAppServId,
    this.isRepeat,
    this.id,
  });

  factory SuccessAppointmentModel.fromJson(Map<String, dynamic> json) =>
      SuccessAppointmentModel(
        isActive: json["IsActive"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"],
        editedBy: json["EditedBy"],
        editedOn: json["EditedOn"],
        appointmentId: json["AppointmentId"],
        businessId: json["BusinessId"],
        staffId: json["StaffId"],
        categoryId: json["CategoryId"],
        subCategoryId: json["SubCategoryId"],
        discount: json["Discount"],
        address: json["Address"],
        addressE: json["AddressE"],
        serviceId: json["ServiceId"],
        subServiceId: json["SubServiceId"],
        businessServiceId: json["BusinessServiceId"],
        price: json["Price"],
        balance: json["Balance"],
        serviceDate: DateTime.parse(json["ServiceDate"]),
        startTime: DateTime.parse(json["StartTime"]),
        endTime: DateTime.parse(json["EndTime"]),
        appointmentTimeSlotId: json["AppointmentTimeSlotId"],
        serviceDurationId: json["ServiceDurationId"],
        duration: json["Duration"],
        durationH: json["DurationH"],
        subServiceName: json["SubServiceName"],
        isPunchCardAvailable: json["isPunchCardAvailable"],
        isPunchCardAdded: json["isPunchCardAdded"],
        status: json["Status"],
        clientFamilyId: json["ClientFamilyId"],
        isWaitingList: json["IsWaitingList"],
        parentAppServId: json["ParentAppServId"],
        isRepeat: json["IsRepeat"],
        id: json["Id"],
      );
}

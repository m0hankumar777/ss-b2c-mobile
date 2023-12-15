import 'package:B2C/model/BookAppointment/available_dates_model.dart';
import 'package:B2C/model/BookAppointment/available_slots_model.dart';
import 'package:B2C/model/BookAppointment/promo_code_model.dart';
import 'package:B2C/model/BookAppointment/success_appointment.dart';
import 'package:get/get.dart';

import '../model/Business/business_staff_model.dart';
import '../model/Business/Services/business_subcategory_model.dart';
import '../model/profile/credit_card_model.dart';
import '../services/Business/bookappointment_service.dart';

class BookAppointmentController extends GetxController {
  RxList<AddedServiceModel> addedServices = <AddedServiceModel>[].obs;
  RxList<AddedSubServiceModel> addedSubServices = <AddedSubServiceModel>[].obs;
  RxList<AvailableSlotModel> availableSlots = <AvailableSlotModel>[].obs;
  Rx<SuccessAppointmentModel> appointmentSuccess =
      SuccessAppointmentModel().obs;
  RxList<PromoCodeModel> promoCodes = <PromoCodeModel>[].obs;
  Rx<PaymentDetailsModel> cardDetail = PaymentDetailsModel().obs;
  RxInt l4 = 0.obs;
  RxBool isCardAdded = false.obs;

  Future getCreditCardDetails(int id) async {
    if (await BookAppointmentServices().getCreditCardDetail(id) == 204) {
      return 204;
    } else {
      cardDetail.value =
          await BookAppointmentServices().getCreditCardDetail(id);
      isCardAdded.value = true;
      return cardDetail;
    }
  }

  clearAddedService() {
    if (addedServices.isNotEmpty) {
      addedServices.clear();
    } if (addedSubServices.isNotEmpty) {
      addedSubServices.clear();
    }
  }

  Future<List<StaffModel>> getAvailableStaffForService(
      int businessId, List<Map> serviceId) async {
    List<StaffModel> staffList = await BookAppointmentServices()
        .getAvailableStaffForService(businessId, serviceId);
    return staffList;
  }

  getAvailbleDatesForStaff(int staffId, int businessId) async {
    List<AvailableDatesModel> dates = await BookAppointmentServices()
        .getAvailableDatesForStaff(staffId, businessId);
    return dates;
  }

  Future<int> getAvailbleSlotForStaff(
      int businessId, int staffId, String date, List serviceList) async {
    List<AvailableSlotModel> slots = await BookAppointmentServices()
        .getAvailableSlot(businessId, staffId, date, serviceList);
    availableSlots.value = slots;
    if (availableSlots.isNotEmpty) {
      return 200;
    } else {
      return 201;
    }
  }

  Future<Map> getCardDetails() async {
    Map cardDetails = {};
    cardDetails = await BookAppointmentServices().getCardDetails();
    return cardDetails;
  }

  bookAppointmentApi(Map data) async {
    try {
      appointmentSuccess.value =
          (await BookAppointmentServices().bookAppointmentApi(data))!;
      return "success";
    } catch (e) {
      return null;
    }
  }

  Future<String> editAppointmentApi(Map data,double lat, double long) async {
    String result = await BookAppointmentServices().editAppointmentApi(data,lat,long);

    return result;
  }

  Future<String> getPaymentUrl() async {
    String url = await BookAppointmentServices().getPaymentUrl();

    return url;
  }

  Future<int> getPromoCode() async {
    List<PromoCodeModel> promo = await BookAppointmentServices().getPromoCode();

    List<PromoCodeModel> dummyPromo = [];
    for (var element in promo) {
      if (element.isActive && checkValidDate(element)) {
        dummyPromo.add(element);
      }
    }
    promoCodes.value = dummyPromo;
    if (promoCodes.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }

  checkValidDate(PromoCodeModel element) {
    if (DateTime.now().isAfter(element.validFrom) &&
        DateTime.now()
            .isBefore(element.expiredAt.add(const Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }
}

class AddedServiceModel {
  SubCategoryModel subcategory;

  ServiceList services;

  AddedServiceModel({required this.subcategory, required this.services});
}

class AddedSubServiceModel {
  SubCategoryModel subcategory;

  ServiceList services;
  SubServiceList subService;
  AddedSubServiceModel(
      {required this.subcategory,
      required this.services,
      required this.subService});
}

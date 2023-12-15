import 'package:B2C/model/appointment_list_model.dart';
import 'package:B2C/services/appointmentlist_service.dart';
import 'package:get/get.dart';

class AppointmentListController extends GetxController {
  AppointmentListService appointmentService = AppointmentListService();
  Rx<PastFutureAppointmentsModel> appointmentData =
      PastFutureAppointmentsModel().obs;

  var appointmentListCount = ''.obs;

  Future getAppointnentsData(int clientId,double lat, double long) async {
    appointmentData.value =
        await appointmentService.getAppointmentData(clientId,lat,long);
  }

  Future<int> cancelAppointment(int appointmentId, int custId) async {
    int returnValue =
        await appointmentService.cancelAppointment(appointmentId, custId);
    return returnValue;
  }

  getFutureAppointmentCountList(int clientId) async {
    appointmentListCount.value =
        await appointmentService.getFutureAppointmentCount(clientId);
  }
}

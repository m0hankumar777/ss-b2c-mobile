// ignore: file_names
import 'package:B2C/model/appointment_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:B2C/const/url.dart' as apiurl;

class AppointmentListService {
  Future getAppointmentData(int clientId, double lat, double long) async {
    String url =
        "${apiurl.baseUrl}Profile/GetAllPastFutureClientAppointmentByCliMobile?customerId=$clientId&latitude=$lat&longitude=$long";
    final response = await http.get(Uri.parse(url));
   
    if (response.statusCode == 200) {
      PastFutureAppointmentsModel result =
          pastFutureAppointmentsModelFromJson(response.body);
      return result;
    } else {
      return response.statusCode;
    }
  }

  Future<int> cancelAppointment(int appointmentId, int custId) async {
    DateTime createdOn = DateTime.now();
    final url =
        "${apiurl.baseUrl}Profile/CancelAppoinment?AppoinmentId=$appointmentId&customerId=$custId&Date=${createdOn.toIso8601String()}";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      return 200;
    } else {
      return 500;
    }
  }

  getFutureAppointmentCount(int customerId) async {
    String url =
        "${apiurl.baseUrl}Profile/FutureAppoinmentCount?customerId=$customerId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}


import 'package:B2C/model/punchcard_model.dart';
import 'package:http/http.dart' as http;
import 'package:B2C/const/url.dart' as apiurl;


class PunchCardService {
Future<List<PunchCardModel>> getAvailablePunchCards(
    int clientId,
   ) async {
    String url =
        "${apiurl.baseUrl}Profile/PunchCard?customerId=$clientId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<PunchCardModel> punchCardsList = punchCardModelFromJson(response.body);
      return punchCardsList;
    } else {
      return [];
    }
  }
}

 
    


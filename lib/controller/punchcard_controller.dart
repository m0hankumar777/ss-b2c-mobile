import 'package:B2C/model/punchcard_model.dart';
import 'package:B2C/services/punchcard_service.dart';
import 'package:get/get.dart';

class PunchCardController extends GetxController {
  RxList<PunchCardModel> punchCardList = <PunchCardModel>[].obs;
  PunchCardService punchservice = PunchCardService();

  Future getAllPunchCards(int clientId) async {
    punchCardList.value = await punchservice.getAvailablePunchCards(clientId);
    if (punchCardList.isNotEmpty) {
      return 200;
    } else {
      return 300;
    }
  }
}

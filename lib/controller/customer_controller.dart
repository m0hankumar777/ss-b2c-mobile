import 'package:get/get.dart';
import 'package:B2C/controller/login_controller.dart' as login;
import 'package:hive/hive.dart';

import '../model/Authentication/customer_model.dart';

class CustomerController extends GetxController {
  var token = ''.obs;
  Rx<Customer> custInfo = Customer().obs;

  getToken() {
    var tokens = login.getToken();
    token.value = tokens;
  }

  getUserInformation() {
    var box = Hive.box<Customer>('customer');
    Customer? user = box.get('userInfo');
    if (user != null) {
      custInfo.value = user;
    }
  }
}

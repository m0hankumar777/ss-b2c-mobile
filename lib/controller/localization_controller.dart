import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  Rx<Locale> locale = const Locale('en', 'US').obs;
  RxString localString = 'en_US'.obs;
  RxString flag = 'english'.obs;
  RxBool isHebrew = false.obs;
  void changeLocale(Locale localee) {
    locale.value = localee;
    if (localee == const Locale('he', 'IL')) {
      Get.updateLocale(localee);
      isHebrew.value = true;
      flag.value = 'hebrew';
      localString.value = 'he_IL';
    } else {
      Get.updateLocale(localee);
      isHebrew.value = false;
      flag.value = 'english';
      localString.value = 'en_US';
    }
  }
}

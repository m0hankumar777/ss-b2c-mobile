import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxInt queIndex = 0.obs;

  quesIndex(index) {
    queIndex.value = index;
  }

  changeIndex(int index) {
    pageIndex.value = index;
  }
}

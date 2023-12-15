import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/services/profileScreen/profile_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:B2C/controller/login_controller.dart' as loginauth;
import '../model/profile/profile_model.dart';

class ProfileController extends GetxController {
  ProfileServices profileServices = ProfileServices();
  Rx<ProfileModel> profileInformation = ProfileModel().obs;
  RxBool isLoad = true.obs;
  RxString englishGender = "".obs;
  RxString hebrewGender = "".obs;
  final customerController = Get.put(CustomerController());
  RxBool userInOrOut = false.obs;
  final profileService = ProfileServices();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  getProfileInfo() async {
    if (profileServices
            .getProfileInformation(customerController.custInfo.value.id!)
            .isBlank ==
        false) {
      profileInformation.value = await profileServices
          .getProfileInformation(customerController.custInfo.value.id!);
      englishGender.value = profileInformation.value.gender == 'זָכָר'
          ? "Male"
          : profileInformation.value.gender == 'נְקֵבָה'
              ? "Female"
              : capitalize(profileInformation.value.gender.toString().tr);
      hebrewGender.value = profileInformation.value.gender
                  .toString()
                  .toLowerCase() ==
              "male"
          ? 'זָכָר'
          : profileInformation.value.gender.toString().toLowerCase() == "female"
              ? 'נְקֵבָה'
              : profileInformation.value.gender.toString();
      isLoad.value = false;
    }
  }

  Future<String> deleteClientApi() async {
    String msg = await profileServices
        .deleteClientApi(customerController.custInfo.value.id!);
    return msg;
  }

  introScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAppPreviouslyLaunched =
        prefs.getBool('isAppPreviouslyLaunched') ?? false;
    if (!isAppPreviouslyLaunched) {
      prefs.setBool('isAppPreviouslyLaunched', true);
      if (loginauth.getLoginStatus() == true) {
        userInOrOut.value = true;
      }
    } else {
      if (loginauth.getLoginStatus() == true) {
        userInOrOut.value = true;
      }
    }
  }
}

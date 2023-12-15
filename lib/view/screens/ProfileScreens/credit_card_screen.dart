import 'package:B2C/controller/book_appointment_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/view/screens/BookAppointment/yaad_pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/customer_controller.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key});

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  final bookAppointmentController = Get.put(BookAppointmentController());
  final customerController = Get.put(CustomerController());
  final localizationController = Get.put(LocalizationController());
  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    creditCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: InkWell(
          onTap: () {
            // Get.to(CreditDetails());
            Get.to(() => const YaadPayScreen());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              height: Get.height * .07,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colr.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: CommenTextWidget(
                s: bookAppointmentController.isCardAdded.value
                    ? "Update Credit Card".tr
                    : "Add Credit Card".tr,
                size: 18,
                clr: Colors.white,
              )),
            ),
          ),
        ),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
            bottomOpacity: 0,
            leading: localizationController.isHebrew.value
                ? null
                : IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                      size: 18,
                    )),
            actions: [
              localizationController.isHebrew.value
                  ? IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                        size: 18,
                      ))
                  : Container()
            ],
            centerTitle: true,
            title: CommenTextWidget(
              s: "Credit Card".tr,
              clr: Colors.black,
              size: 23,
            )),
        body: !isLoad
            ? Obx(
                () => bookAppointmentController.isCardAdded.value
                    ? SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: bookAppointmentController.isCardAdded.value
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colr.primary,
                                      ),
                                      child: ListTile(
                                        subtitle: CommenTextWidget(
                                          s: "**** **** **** ${bookAppointmentController.l4.value}"
                                              .tr,
                                          size: 16,
                                          clr: Colors.white,
                                        ),
                                        title: CommenTextWidget(
                                          s: "Credit Number".tr,
                                          size: 18,
                                          clr: Colors.white,
                                        ),
                                        // trailing: Text('data'),
                                      ))
                                  : const ListTile(),
                            ),
                          ],
                        ),
                      )
                    : SafeArea(
                        child: Center(
                            child: SizedBox(
                          width: Get.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                  image: AssetImage(
                                      "assets/images/no_credit_card_found.png")),
                              const SizedBox(
                                height: 20,
                              ),
                              CommenTextWidget(
                                s: 'No Results Have Been Found'.tr,
                                size: 16,
                                clr: Colr.primary,
                              )
                            ],
                          ),
                        )),
                      ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colr.primary,
                ),
              ));
  }

  creditCard() {
    bookAppointmentController
        .getCreditCardDetails(customerController.custInfo.value.id!)
        .then((value) {
      if (value == 204) {
        bookAppointmentController.isCardAdded.value = false;
        setState(() {
          isLoad = false;
        });
      } else {
        bookAppointmentController.l4.value =
            bookAppointmentController.cardDetail.value.l4Digit!;
        bookAppointmentController.isCardAdded.value = true;
        setState(() {
          isLoad = false;
        });
      }
    });
  }
}

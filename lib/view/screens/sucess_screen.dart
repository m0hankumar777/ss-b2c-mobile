import 'package:B2C/controller/appointmentlist_controller.dart';
import 'package:B2C/controller/book_appointment_controller.dart';
import 'package:B2C/controller/business_controller.dart';
import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/view/screens/HomeScreen/home_screen.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class Success extends StatefulWidget {
  DateTime staTime;
  DateTime enTime;
  Success({super.key, required this.staTime, required this.enTime});
  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  final bookAppointmentController = Get.put(BookAppointmentController());
  final localizationController = Get.put(LocalizationController());
  final businessController = Get.put(BusinessController());
  final customerController = Get.put(CustomerController());

  final appointmentListController = Get.put(AppointmentListController());
  RxBool isGpsEnabled = true.obs;
  Location location = Location();
  // ignore: prefer_typing_uninitialized_variables
  var lati;
  // ignore: prefer_typing_uninitialized_variables
  var longi;
  // bool isLoading = false;

  whenBack() {
    Get.offAll(HomeScreen(
      selectedIndex: 1,
      isQues: true,
    ));
  }

  @override
  void initState() {
    super.initState();
    getAppointmentCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return whenBack();
      },
      child: Scaffold(
          backgroundColor: Colr.primary,
          body: Center(
            child: Obx(
              () => SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.15,
                    ),
                    Image.asset("assets/images/success.png"),
                    const SizedBox(
                      height: 10,
                    ),
                    CommenTextWidget(
                      s: "The appointment was successfully made!".tr,
                      clr: Colr.primaryLight,
                      size: Get.height * .022,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colr.primaryLight,
                          borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: Get.width * 0.15,
                                  height: Get.height * 0.07,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(businessController
                                                  .businessData
                                                  .value
                                                  .salonDetail!
                                                  .imageUrl ??
                                              ""),
                                          fit: BoxFit.fill),
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: Get.width * 0.64,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.4,
                                        child: CommenTextWidget(
                                          s: businessController.businessData
                                              .value.salonDetail!.name!,
                                          size: Get.height * 0.024,
                                          fw: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.4,
                                            child: CommenTextWidget(
                                              clr: Colors.grey,
                                              size: 12,
                                              s: businessController.businessData
                                                  .value.salonDetail!.address!,
                                              of: TextOverflow.ellipsis,
                                              mxL: 2,
                                            ),
                                          ),
                                          CommenTextWidget(
                                              s: '${businessController.businessData.value.salonDetail!.distance} '
                                                  '${'Km'.tr} ',
                                              align: TextAlign.left,
                                              clr: Colors.black54,
                                              size: 12,
                                              fw: FontWeight.w300),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              height: 20,
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommenTextWidget(
                                  s: "Service".tr,
                                  size: Get.height * 0.018,
                                  clr: Colors.grey,
                                ),
                                CommenTextWidget(
                                  s: checkNoService()
                                      ? bookAppointmentController
                                              .addedServices.isNotEmpty
                                          ? localizationController
                                                  .isHebrew.value
                                              ? "${(bookAppointmentController.addedServices.length + bookAppointmentController.addedSubServices.length) - 1} + ${bookAppointmentController.addedServices[0].services.serviceNameH}"
                                              : "${bookAppointmentController.addedServices[0].services.serviceName} + ${(bookAppointmentController.addedServices.length + bookAppointmentController.addedSubServices.length) - 1}"
                                          : localizationController
                                                  .isHebrew.value
                                              ? "${(bookAppointmentController.addedServices.length + bookAppointmentController.addedSubServices.length) - 1} + ${bookAppointmentController.addedSubServices[0].services.serviceNameH}"
                                              : "${bookAppointmentController.addedSubServices[0].services.serviceName} + ${(bookAppointmentController.addedServices.length + bookAppointmentController.addedSubServices.length) - 1}"
                                      : bookAppointmentController
                                              .addedServices.isNotEmpty
                                          ? localizationController
                                                  .isHebrew.value
                                              ? bookAppointmentController
                                                  .addedServices[0]
                                                  .services
                                                  .serviceNameH
                                              : bookAppointmentController
                                                  .addedServices[0]
                                                  .services
                                                  .serviceName
                                          : bookAppointmentController
                                                  .addedSubServices.isNotEmpty
                                              ? localizationController
                                                      .isHebrew.value
                                                  ? bookAppointmentController
                                                      .addedSubServices[0]
                                                      .services
                                                      .serviceNameH
                                                  : bookAppointmentController
                                                      .addedSubServices[0]
                                                      .services
                                                      .serviceName
                                              : '',
                                  size: Get.height * 0.018,
                                  clr: Colors.black,
                                )
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommenTextWidget(
                                  s: "Date".tr,
                                  size: Get.height * 0.018,
                                  clr: Colors.grey,
                                ),
                                CommenTextWidget(
                                  s: DateFormat(
                                          "EEEE, dd MMMM, yyyy",
                                          localizationController.isHebrew.value
                                              ? 'he'
                                              : 'en')
                                      .format(bookAppointmentController
                                          .appointmentSuccess
                                          .value
                                          .serviceDate!),
                                  size: Get.height * 0.018,
                                  clr: Colr.primary,
                                )
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommenTextWidget(
                                  s: "Time".tr,
                                  size: Get.height * 0.018,
                                  clr: Colors.grey,
                                ),
                                CommenTextWidget(
                                    s: localizationController.isHebrew.value
                                        ? "${getAppointmentTime(bookAppointmentController.appointmentSuccess.value.endTime!)} - ${getAppointmentTime(bookAppointmentController.appointmentSuccess.value.startTime!)}"
                                        : "${getAppointmentTime(bookAppointmentController.appointmentSuccess.value.startTime!)} - ${getAppointmentTime(bookAppointmentController.appointmentSuccess.value.endTime!)}",
                                    size: Get.height * 0.018,
                                    clr: Colr.primary,
                                    fw: FontWeight.w400),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommenTextWidget(
                                  s: "Price".tr,
                                  size: Get.height * 0.018,
                                  clr: Colors.grey,
                                ),
                                CommenTextWidget(
                                  s: "${"NIS".tr} ${bookAppointmentController.appointmentSuccess.value.price!}",
                                  size: Get.height * 0.018,
                                  clr: Colr.primary,
                                )
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  Get.offAll(HomeScreen(
                                    selectedIndex: 1,
                                    isQues: true,
                                  ));
                                },
                                child: Container(
                                  height: Get.height * 0.07,
                                  width: Get.width * 1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffF2F2F2)),
                                  child: Center(
                                    child: CommenTextWidget(
                                      s: "Detail".tr,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.09,
                    ),
                    InkWell(
                      onTap: () {
                        Add2Calendar.addEvent2Cal(buildEvent());
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: Get.height * 0.07,
                        width: Get.width * 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffF2F2F2)),
                        child: Center(
                          child: CommenTextWidget(
                            s: "Add to Diary".tr,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Get.offAll(HomeScreen(
                          selectedIndex: 1,
                          isQues: true,
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        height: Get.height * 0.07,
                        width: Get.width * 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colr.primaryLight)),
                        child: Center(
                          child: CommenTextWidget(
                            clr: Colr.primaryLight,
                            s: "My Appointments".tr,
                            size: 17,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  checkNoService() {
    if ((bookAppointmentController.addedServices.length +
            bookAppointmentController.addedSubServices.length) >
        1) {
      return true;
    }
    return false;
  }

  getAppointmentTime(DateTime dte) {
    String date = DateFormat('HH:mm').format(dte);
    return date;
  }

  Event buildEvent({
    Recurrence? recurrence,
  }) {
    return Event(
      title: (bookAppointmentController.addedServices.isNotEmpty
              ? (localizationController.isHebrew.value
                  ? (bookAppointmentController.addedServices
                      .map((c) => c.services.serviceNameH)
                      .join(','))
                  : (bookAppointmentController.addedServices
                      .map((c) => c.services.serviceName)
                      .join(', ')))
              : '') +
          (bookAppointmentController.addedSubServices.isNotEmpty
              ? ' subService  ${bookAppointmentController.addedSubServices.map((c) => c.subService.subServiceName).join(', ')}'
              : ''),

      description: 'Glamz',
      location: localizationController.isHebrew.value
          ? bookAppointmentController.appointmentSuccess.value.address
          : bookAppointmentController.appointmentSuccess.value.addressE,
      startDate: widget.staTime,
      endDate: widget.enTime,
      allDay: false,
      // iosParams: IOSParams(
      //   reminder: Duration(minutes: 40),
      //   url: "http://example.com",
      // ),
      // androidParams: AndroidParams(
      //   emailInvites: ["test@example.com"],
      // ),
      recurrence: recurrence,
    );
  }

  Future<void> getAppointmentCount() async {
    await appointmentListController
        .getFutureAppointmentCountList(customerController.custInfo.value.id!);
  }
}

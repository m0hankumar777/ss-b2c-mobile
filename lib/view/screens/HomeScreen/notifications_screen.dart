import 'package:B2C/controller/homescreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/customer_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/login_controller.dart';
import '../../../utility/themes_b2c.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final loginController = Get.put(LoginController());
  final notificationController = Get.put(HomeScreenController());
  final localizationController = Get.put(LocalizationController());
  final customerController = Get.put(CustomerController());
  bool isStart = false;
  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  fetchAPI() async {
    await notificationController
        .getAllNotifications(customerController.custInfo.value.id!);
    if (mounted) {
      setState(() {
        isStart = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottomOpacity: 0,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: localizationController.isHebrew.value ? null : iconButton(),
          actions: [
            localizationController.isHebrew.value ? iconButton() : Container(),
          ],
          centerTitle: true,
          title: CommenTextWidget(
            s: "Notifications".tr,
            fw: FontWeight.bold,
            size: 18,
            clr: Colors.black,
          ),
        ),
        body: isStart
            ? Obx(() => SingleChildScrollView(
                  child: notificationController.notifications.isEmpty
                      ? Center(
                          child: Column(
                          children: [
                            SizedBox(
                              height: Get.height / 3.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/no_reviews.png',
                                width: 250,
                              ),
                            ),
                            CommenTextWidget(
                              s: 'No Results Have Been Found'.tr,
                              size: 16,
                              clr: Colr.primary,
                            ),
                          ],
                        ))
                      : Column(
                          children: List.generate(
                              notificationController.notifications.length,
                              (index) {
                          return InkWell(
                            onTap: () async {
                              await notificationController
                                  .getAppointmentDetailsByNotification(
                                      notificationController
                                          .notifications[index].appointmentId);
                              await Get.bottomSheet(appointmentDetail(
                                  notificationController
                                      .notifications[index].message));
                              await notificationController
                                  .isNotificationRead(notificationController
                                      .notifications[index].id)
                                  .then((value) async {
                                if (value == 200) {
                                  await notificationController
                                      .getAllNotifications(
                                          customerController.custInfo.value.id!)
                                      .then((value) async {
                                    if (value == 200) {
                                      await notificationController
                                          .getUnreadNotificationsCount(
                                              customerController
                                                  .custInfo.value.id!);
                                    }
                                  });
                                }
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white10,
                                    ),
                                    width: double.infinity,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                iconSize: 15,
                                                color: Colors.grey,
                                                // ignore: unrelated_type_equality_checks
                                                icon: (notificationController
                                                                .notifications[
                                                                    index]
                                                                .objectType ==
                                                            "Appointment-Add" ||
                                                        // ignore: unrelated_type_equality_checks
                                                        notificationController
                                                                .notifications[
                                                                    index]
                                                                .objectType ==
                                                            "Appointment-Update")
                                                    ? const Icon(
                                                        Icons.calendar_month)
                                                    // ignore: unrelated_type_equality_checks
                                                    : notificationController
                                                                .notifications[
                                                                    index]
                                                                .objectType ==
                                                            "Appointment-Complete"
                                                        ? const Icon(
                                                            Icons.check)
                                                        // ignore: unrelated_type_equality_checks
                                                        : (notificationController.notifications[index].objectType ==
                                                                    "Appointment-Cancel-Client fee" ||
                                                                // ignore: unrelated_type_equality_checks
                                                                notificationController.notifications[index].objectType ==
                                                                    "Appointment-Noshow-Client fee" ||
                                                                // ignore: unrelated_type_equality_checks
                                                                notificationController
                                                                        .notifications[
                                                                            index]
                                                                        .objectType ==
                                                                    "Appointment-Noshow")
                                                            ? const Icon(Icons
                                                                .announcement)
                                                            // ignore: unrelated_type_equality_checks
                                                            : notificationController
                                                                        .notifications[index]
                                                                        .objectType ==
                                                                    "Appointment-Rescheduled"
                                                                ? const Icon(Icons.calendar_month)
                                                                // ignore: unrelated_type_equality_checks
                                                                : notificationController.notifications[index].objectType == "Appointment-Cancel"
                                                                    ? const Icon(Icons.block_flipped)
                                                                    // ignore: unrelated_type_equality_checks
                                                                    : notificationController.notifications[index].objectType == "Refund fee"
                                                                        ? const Icon(Icons.credit_card)
                                                                        // ignore: unrelated_type_equality_checks
                                                                        : (notificationController.notifications[index].objectType == "Appointment-3 hours Left" || notificationController.notifications[index].objectType == "Appointment-1 Day Before")
                                                                            ? const Icon(Icons.alarm)
                                                                            // ignore: unrelated_type_equality_checks
                                                                            : notificationController.notifications[index].objectType == "Invoice-Created"
                                                                                ? const Icon(Icons.document_scanner)
                                                                                : const Icon(Icons.calendar_month),
                                                onPressed: () {},
                                              ),
                                              Text(
                                                '${DateFormat('dd.MM.yyyy').format(notificationController.notifications[index].createdOn)} ',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              // Text(
                                              //   DateFormat('HH:mm').format(
                                              //       notificationController
                                              //           .notifications[index]
                                              //           .createdOn),
                                              //   style: const TextStyle(
                                              //       color: Colors.grey,
                                              //       fontSize: 14,
                                              //       fontWeight:
                                              //           FontWeight.normal),
                                              // ),
                                            ],
                                          ),
                                          Text(
                                            notificationController
                                                .notifications[index].message,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: notificationController
                                                        .notifications[index]
                                                        .read
                                                    ? Colors.grey
                                                    : Colors.black,
                                                fontSize: 16,
                                                fontWeight:
                                                    notificationController
                                                            .notifications[
                                                                index]
                                                            .read
                                                        ? FontWeight.normal
                                                        : FontWeight.bold),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                      height: 50,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                        color: Colr.primary,
                                                      )));
                                                },
                                              );
                                              await notificationController
                                                  .isNotificationRead(
                                                      notificationController
                                                          .notifications[index]
                                                          .id)
                                                  .then((value) async {
                                                if (value == 200) {
                                                  await notificationController
                                                      .getAllNotifications(
                                                          customerController
                                                              .custInfo
                                                              .value
                                                              .id!)
                                                      .then((value) async {
                                                    if (value == 200) {
                                                      await notificationController
                                                          .getUnreadNotificationsCount(
                                                              customerController
                                                                  .custInfo
                                                                  .value
                                                                  .id!);
                                                    }
                                                  });
                                                }
                                              });
                                              Future.delayed(
                                                  const Duration(seconds: 5),
                                                  () async {
                                                Navigator.pop(
                                                    context); //pop dialog
                                              }).then(
                                                (value) async {
                                                  await notificationController
                                                      .getAppointmentDetailsByNotification(
                                                          int.parse(
                                                              notificationController
                                                                  .notifications[
                                                                      index]
                                                                  .appointmentId));
                                                  await Get.bottomSheet(
                                                      appointmentDetail(
                                                          notificationController
                                                              .notifications[
                                                                  index]
                                                              .message));
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: CommenTextWidget(
                                                s: 'View Details'.tr,
                                                size: 14,
                                                clr: Colors.red,
                                                fw: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                                const Divider(
                                  thickness: 2,
                                )
                              ]),
                            ),
                          );
                        })),
                ))
            : Center(
                child: CircularProgressIndicator(
                  color: Colr.primary,
                ),
              ));
  }

  IconButton iconButton() {
    return IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          localizationController.isHebrew.value
              ? Icons.arrow_forward_ios_outlined
              : Icons.arrow_back_ios_new_outlined,
          color: Colors.black,
          size: 20,
        ));
  }

  Widget appointmentDetail(String message) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CommenTextWidget(
              s: 'Appointment Details'.tr,
              size: 20,
              fw: FontWeight.bold,
            ),
            const SizedBox(
              height: 20,
            ),
            nameAndAddress(),
            const Divider(),
            appointments(message),
          ],
        ),
      ),
    );
  }

  nameAndAddress() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width * 0.17,
                height: Get.width * 0.17,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5),
                    image: notificationController
                                .appointmentDetails.value.profileImage !=
                            null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(notificationController
                                .appointmentDetails.value.profileImage!))
                        : const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/glamz-logo.png"))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          notificationController
                              .appointmentDetails.value.businessName!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          notificationController
                              .appointmentDetails.value.businessAddressE!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ));
  }

  appointments(String message) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommenTextWidget(
              s: 'Appointment Date:'.tr,
              size: 16,
            ),
            CommenTextWidget(
                s: notificationController
                    .appointmentDetails.value.appointmentDate!
                    .substring(0, 10))
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommenTextWidget(
              s: 'Appointment Time:'.tr,
              size: 16,
            ),
            CommenTextWidget(
                s: notificationController
                    .appointmentDetails.value.appointmentStartTime!
                    .toString()
                    .substring(11, 16))
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommenTextWidget(
                s: '${'Services'.tr}: ',
                size: 16,
              ),
              CommenTextWidget(
                  s: notificationController
                      .appointmentDetails.value.servList![0].serviceName)
            ],
          )),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommenTextWidget(
              s: '${'Price'.tr}: ',
              size: 16,
            ),
            CommenTextWidget(
                s: '${notificationController.appointmentDetails.value.totalPrice!} ${'NIS'.tr}')
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.85,
              child: CommenTextWidget(
                s: '${'Message:'.tr}  $message',
                size: 16,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}

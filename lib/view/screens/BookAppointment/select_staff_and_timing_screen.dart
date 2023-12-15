import 'package:B2C/controller/business_controller.dart';
import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/controller/book_appointment_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/main.dart';
import 'package:B2C/model/appointment_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:B2C/const/url.dart' as apiurl;
import 'package:B2C/model/BookAppointment/available_dates_model.dart';
import 'package:B2C/model/BookAppointment/available_slots_model.dart';
import 'package:B2C/model/BookAppointment/promo_code_model.dart';

import 'package:B2C/utility/colors_util.dart';
import 'package:B2C/utility/themes_b2c.dart';

import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/utility/widget_helper/common_elevated_button.dart';
import 'package:B2C/view/screens/sucess_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../../controller/homescreen_controller.dart';
import '../../../model/Business/business_staff_model.dart';

// ignore: must_be_immutable
class SelectStaffAndTimingScreen extends StatefulWidget {
  int businessId;
  ClientAppointment? clientAppointment;
  // ignore: use_key_in_widget_constructors
  SelectStaffAndTimingScreen(
      {required this.businessId, this.clientAppointment});

  @override
  State<SelectStaffAndTimingScreen> createState() =>
      _SelectStaffAndTimingScreenState();
}

class _SelectStaffAndTimingScreenState
    extends State<SelectStaffAndTimingScreen> {
  bool isMorning = true;
  bool isNoon = false;
  bool isPromoApplied = false;
  bool isEvening = false;
  bool isStaffLoad = true;
  bool isBookButtonLoad = false;
  bool isCustomWorkingHours = false;
  int hourIndex = -1;
  List<DateTime> datess = [];
  List<DateTime> availableDates = [];
  List<AvailableDatesModel> apiDAtesForCheck = [];
  DateTime? selectedDate;
  DateTime? appointmentTime;
  int dateIndex = -2;
  //int staffIndex = -2;
  List<StaffModel> staffList = [];
  List<AvailableSlotModel> morningSlots = [];
  List<AvailableSlotModel> noonSlots = [];
  List<AvailableSlotModel> evening = [];
  double lat = 0.0;
  double long = 0.0;
  int? seletedStaffId;
  AvailableSlotModel? selectedSlot;
  Location location = Location();
  String overlapsMessage = "";
  PromoCodeModel? selectedPromoCode;
  DateTime todayDummy = DateTime(DateTime.now().year, DateTime.now().month, 1);
  final localizationController = Get.put(LocalizationController());
  final bookAppointmentController = Get.put(BookAppointmentController());
  final buisnessController = Get.put(BusinessController());
  final userController = Get.put(CustomerController());
  final notificationController = Get.put(HomeScreenController());
  final customerController = Get.put(CustomerController());
  bool isPromoSelcted = false;
  final scrollConroller = ScrollController();
  @override
  void initState() {
    super.initState();
    getDates();
    if (widget.clientAppointment == null) {
      getAvailableStaffForService();
      getPromoCode();
    } else {
      getAvailbleDate(widget.clientAppointment!.appointmentService[0].staffId);
      getDateIndex();
    }
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: localizationController.isHebrew.value
            ? null
            : IconButton(
                onPressed: () {
                  Get.back();
                  // Get.off(BusinessAboutScreen(widget.businessId));
                },
                icon: Icon(
                  localizationController.isHebrew.value
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  color: Colors.black,
                )),
        actions: localizationController.isHebrew.value
            ? [
                IconButton(
                    onPressed: () {
                      Get.back();
                      // Get.off(BusinessAboutScreen(widget.businessId));
                    },
                    icon: Icon(
                      localizationController.isHebrew.value
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
              ]
            : [],
        elevation: 0,
        title: CommenTextWidget(
          s: "Order a service".tr,
          clr: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
          child: Obx(
        () => Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            serviceTileWidget(),
            widget.clientAppointment == null
                ? servicesListWidget()
                : editServiceListWidget(),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            widget.clientAppointment == null
                ? Column(
                    children: [
                      selectStaffWidget(),
                      const Divider(
                        thickness: 2,
                        height: 50,
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 15,
            ),
            datePickerWidget(),
            const Divider(
              thickness: 2,
              height: 60,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectedDate == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CommenTextWidget(
                          s: "Hour".tr,
                          fw: FontWeight.bold,
                          size: 18,
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                selectedDate == null
                    ? const SizedBox()
                    : Column(
                        children: [
                          hourButtonBarWidget(),
                          const SizedBox(
                            height: 20,
                          ),
                          selectedDate == null
                              ? Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Column(
                                    children: [
                                      Text(
                                          'No Slots available for the selected staff on Selected Date'
                                              .tr),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runSpacing: 10,
                                    children: (morningSlots.isNotEmpty ||
                                            noonSlots.isNotEmpty ||
                                            evening.isNotEmpty)
                                        ? List.generate(
                                            isMorning
                                                ? morningSlots.length
                                                : isNoon
                                                    ? noonSlots.length
                                                    : evening.length, (index) {
                                            return InkWell(
                                              onTap: () {
                                                onSlotClickEvent(index);
                                              },
                                              child: Card(
                                                color: checkSlotEnable(index)
                                                    ? Colors.white
                                                    : Colors.grey[300],
                                                child: Container(
                                                  height: 40,
                                                  width: Get.width * 0.275,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          width: 1.8,
                                                          color: hourIndex ==
                                                                  index
                                                              ? Colr.primary
                                                              : Colors
                                                                  .transparent)),
                                                  child: Center(
                                                      child: CommenTextWidget(
                                                    s: isMorning
                                                        ? morningSlots[index]
                                                            .fromWorkingHours
                                                        : isNoon
                                                            ? noonSlots[index]
                                                                .fromWorkingHours
                                                            : evening[index]
                                                                .fromWorkingHours,
                                                    fw: FontWeight.w600,
                                                  )),
                                                ),
                                              ),
                                            );
                                          })
                                        : List.generate(
                                            1,
                                            (index) => Center(
                                                    child: Column(
                                                  children: [
                                                    Text(
                                                        'No Slots available for the selected staff on Selected Date'
                                                            .tr),
                                                    const SizedBox(
                                                      height: 20,
                                                    )
                                                  ],
                                                ))),
                                  ),
                                ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      )),
      bottomNavigationBar: bottomBarWidget(),
    );
  }

  bottomBarWidget() {
    return Container(
      width: double.infinity,
      height: widget.clientAppointment == null ? 150 : 100,
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(5, 4))
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(5)),
          ),
          widget.clientAppointment == null
              ? Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppButtons(
                        text: "Add Promo code".tr,
                        backgroundColor:
                            isPromoApplied ? Colors.grey[200] : Colr.primary,
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 45,
                        width: Get.width * 0.55,
                        onPressed: () {
                          // Get.bottomSheet(getPromoCodeBottomSheet());
                          if (isPromoApplied) {
                          } else {
                            Get.bottomSheet(getPromoCodeBottomSheet());
                          }
                        },
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommenTextWidget(
                            s: "${getBalancePrice()} ${"NIS".tr}",
                            fw: FontWeight.w600,
                          ),
                          CommenTextWidget(
                            s: "${"Services".tr} X ${bookAppointmentController.addedServices.length + bookAppointmentController.addedSubServices.length}",
                            fw: FontWeight.w600,
                          )
                        ],
                      )
                    ],
                  ))
              : const SizedBox(),
          AppButtons(
            text: widget.clientAppointment == null
                ? "Book Appointment".tr
                : "Update Appointment".tr,
            isLoad: isBookButtonLoad,
            backgroundColor: Colr.primary,
            textColor: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 45,
            width: Get.width * 0.85,
            onPressed: () {
              if (isBookButtonLoad) {
              } else {
                if (widget.clientAppointment == null) {
                  if (seletedStaffId == null) {
                    Fluttertoast.showToast(msg: "Please Select Staff".tr);
                  } else if (selectedDate == null) {
                    Fluttertoast.showToast(msg: "Date is Required".tr);
                  } else if (selectedSlot == null) {
                    Fluttertoast.showToast(msg: "please select slot".tr);
                  } else {
                    setState(() {
                      isBookButtonLoad = true;
                    });
                    bookAppointment();
                  }
                } else {
                  editAppointment();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  hourButtonBarWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(6)),
      height: 40,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  isMorning = true;
                  isNoon = false;
                  isEvening = false;
                  hourIndex = -1;
                  selectedSlot = null;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: isMorning ? Colr.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                    child: CommenTextWidget(
                  s: "morning".tr,
                  size: 15,
                  fw: FontWeight.w500,
                  clr: isMorning ? Colors.white : Colors.black87,
                )),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  isMorning = false;
                  isNoon = true;
                  isEvening = false;
                  hourIndex = -1;
                  selectedSlot = null;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: isNoon ? Colr.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                    child: CommenTextWidget(
                  s: "noon".tr,
                  size: 15,
                  fw: FontWeight.w500,
                  clr: isNoon ? Colors.white : Colors.black87,
                )),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  isMorning = false;
                  isNoon = false;
                  isEvening = true;
                  hourIndex = -1;
                  selectedSlot = null;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: isEvening ? Colr.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                    child: CommenTextWidget(
                  s: "evening".tr,
                  size: 15,
                  fw: FontWeight.w500,
                  clr: isEvening ? Colors.white : Colors.black87,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row serviceTileWidget() {
    return Row(
      children: [
        const SizedBox(
          width: 15,
        ),
        CommenTextWidget(
          s: "Services".tr,
          size: 20,
          fw: FontWeight.w600,
          clr: Colors.black87,
        ),
        const Spacer(),
        widget.clientAppointment == null
            ? AppButtons(
                text: "${"Add".tr} ${"Service".tr}",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                width: 100,
                height: 50,
                backgroundColor: themeLightRed,
                onPressed: () {
                  Get.back();
                },
              )
            : const SizedBox(),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

  servicesListWidget() {
    return Obx(() => Column(
          children: [
            Column(
                children: List.generate(
                    bookAppointmentController.addedServices.length, (index) {
              return Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {
                      bookAppointmentController.addedServices.removeAt(index);

                      setState(() {
                        isStaffLoad = true;
                      });
                      getAvailableStaffForService();
                      if ((bookAppointmentController.addedServices.length +
                              bookAppointmentController
                                  .addedSubServices.length) ==
                          0) {
                        Get.back();
                      }
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: "Delete".tr,
                  ),
                ]),
                child: Column(
                  children: [
                    ListTile(
                      title: CommenTextWidget(
                          s: localizationController.isHebrew.value
                              ? bookAppointmentController
                                  .addedServices[index].services.serviceNameH
                              : bookAppointmentController
                                  .addedServices[index].services.serviceName),
                      subtitle: CommenTextWidget(
                          s: localizationController.isHebrew.value
                              ? bookAppointmentController.addedServices[index]
                                      .services.durationH ??
                                  ""
                              : bookAppointmentController
                                      .addedServices[index].services.duration ??
                                  ""),
                      trailing: CommenTextWidget(
                        s: "${bookAppointmentController.addedServices[index].services.price} ${"NIS".tr}",
                        fw: FontWeight.w600,
                        clr: Colors.black87,
                      ),
                    ),
                    bookAppointmentController.addedSubServices.isNotEmpty
                        ? const Divider(
                            thickness: 1.5,
                            endIndent: 20,
                            indent: 20,
                          )
                        : index !=
                                bookAppointmentController.addedServices.length -
                                    1
                            ? const Divider(
                                thickness: 1.5,
                                endIndent: 20,
                                indent: 20,
                              )
                            : const SizedBox(
                                height: 10,
                              )
                  ],
                ),
              );
            })),
            Column(
              children: List.generate(
                  bookAppointmentController.addedSubServices.length,
                  (index) => Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {
                              bookAppointmentController.addedSubServices
                                  .removeAt(index);
                              if ((bookAppointmentController
                                          .addedServices.length +
                                      bookAppointmentController
                                          .addedSubServices.length) ==
                                  0) {
                                Get.back();
                              }
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: "Cancel".tr,
                          ),
                        ]),
                        child: Column(
                          children: [
                            ListTile(
                              title: CommenTextWidget(
                                  s: localizationController.isHebrew.value
                                      ? (bookAppointmentController
                                          .addedSubServices[index]
                                          .services
                                          .serviceNameH)
                                      : "${bookAppointmentController.addedSubServices[index].services.serviceName}(${bookAppointmentController.addedSubServices[index].subService.subServiceName})"),
                              subtitle: CommenTextWidget(
                                  s: localizationController.isHebrew.value
                                      ? bookAppointmentController
                                              .addedSubServices[index]
                                              .subService
                                              .durationH ??
                                          ""
                                      : bookAppointmentController
                                              .addedSubServices[index]
                                              .subService
                                              .duration ??
                                          ""),
                              trailing: CommenTextWidget(
                                s: "${bookAppointmentController.addedSubServices[index].subService.price} ${"NIS".tr}",
                                fw: FontWeight.w600,
                                clr: Colors.black87,
                              ),
                            ),
                            index !=
                                    bookAppointmentController
                                            .addedSubServices.length -
                                        1
                                ? const Divider(
                                    thickness: 1.5,
                                    endIndent: 20,
                                    indent: 20,
                                  )
                                : const SizedBox(
                                    height: 10,
                                  )
                          ],
                        ),
                      )),
            )
          ],
        ));
  }

  selectStaffWidget() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CommenTextWidget(
                s: "Select Staff".tr,
                size: 20,
                fw: FontWeight.w600,
                clr: Colors.black87,
              ),
            ),
          ],
        ),
        isStaffLoad
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircularProgressIndicator(
                  color: Colr.primary,
                ),
              )
            : staffList.isEmpty
                ? Text("No staff perform all this services".tr)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List.generate(staffList.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              seletedStaffId = staffList[index].staffId;
                              bookAppointmentController.availableSlots.value =
                                  [];
                              dateIndex = -2;
                              morningSlots = [];
                              noonSlots = [];
                              evening = [];
                            });
                            getAvailbleDate(staffList[index].staffId);
                          },
                          child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 6),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(-2, 2))
                                  ],
                                  color: Colors.white,
                                  border: Border.all(
                                      color: seletedStaffId ==
                                              staffList[index].staffId
                                          ? Colr.primary
                                          : Colors.transparent,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(15)),
                              height: 80,
                              width: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  staffList[index].imageUrl != null
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            staffList[index].imageUrl!,
                                          ),
                                          radius: 25,
                                        )
                                      : const CircleAvatar(
                                          backgroundImage: AssetImage(
                                            "assets/images/glamz-logo.png",
                                          ),
                                          radius: 25,
                                        ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 110,
                                        child: CommenTextWidget(
                                          of: TextOverflow.ellipsis,
                                          s: staffList[index].firstName,
                                          fw: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: CommenTextWidget(
                                          of: TextOverflow.ellipsis,
                                          s: staffList[index].position == "NULL"
                                              ? ""
                                              : staffList[index].position ?? "",
                                          clr: Colors.black54,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        );
                      })),
                    ),
                  )
      ],
    );
  }

  void getDates() {
    DateTime dte = todayDummy;
    for (int i = 0; i < 32; i++) {
      if (dte.month == todayDummy.month) {
        if (dte.day < DateTime.now().day) {
        } else {
          datess.add(dte);
        }
        dte = dte.add(const Duration(
          days: 1,
        ));
      }
    }
    setState(() {});
  }

  void decreaseMonth(int incDec) {
    if (incDec == -1) {
      datess = [];
      todayDummy = DateTime(todayDummy.year, todayDummy.month - 1, 1);
      DateTime dte = todayDummy;
      for (int i = 0; i < 32; i++) {
        if (dte.month == todayDummy.month) {
          if (todayDummy.month == DateTime.now().month) {
            if (dte.day >= DateTime.now().day) {
              datess.add(dte);
            }
          } else {
            datess.add(dte);
          }
        }
        dte = dte.add(const Duration(days: 1));
      }

      setState(() {});
    } else {
      datess = [];
      todayDummy =
          DateTime(todayDummy.year, todayDummy.month + 1, todayDummy.day);
      DateTime dte = todayDummy;
      for (int i = 0; i < 32; i++) {
        if (dte.month == todayDummy.month) datess.add(dte);
        dte = dte.add(const Duration(days: 1));
      }
      setState(() {});
    }
  }

  datePickerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CommenTextWidget(
            s: "Date".tr,
            size: 20,
            fw: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              beforeDAteCheck()
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        decreaseMonth(-1);
                        scrollConroller
                            .jumpTo(scrollConroller.position.minScrollExtent);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 2,
                                spreadRadius: 0.1)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            localizationController.isHebrew.value
                                ? Icons.keyboard_arrow_right
                                : Icons.keyboard_arrow_left,
                            size: 20,
                          ),
                        ),
                      )),
              CommenTextWidget(
                s: DateFormat('MMMM yyyy',
                        localizationController.isHebrew.value ? 'he' : 'en')
                    .format(todayDummy),
                fw: FontWeight.w600,
                size: 18,
              ),
              afterMonthCheck()
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        decreaseMonth(1);
                        scrollConroller
                            .jumpTo(scrollConroller.position.minScrollExtent);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 2,
                                spreadRadius: 0.1)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            localizationController.isHebrew.value
                                ? Icons.keyboard_arrow_left
                                : Icons.keyboard_arrow_right,
                            size: 20,
                          ),
                        ),
                      ))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        availableDates.isEmpty
            ? const SizedBox()
            : SingleChildScrollView(
                controller: scrollConroller,
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(datess.length, (index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          dateIndex = index;
                        });
                        bookAppointmentController.availableSlots.value = [];
                        morningSlots = [];
                        noonSlots = [];
                        evening = [];

                        if (checkCustomAvailble(datess[index]) == null) {
                          isCustomWorkingHours = false;
                        } else {
                          isCustomWorkingHours = true;
                        }
                        if (checkDAteEnableOrNot(datess[index])) {
                          if (getStaffAttendance(datess[index])) {
                            selectedDate = datess[index];
                            String formatedDate =
                                DateFormat("MM/dd/yyyy").format(selectedDate!);
                            List<Map> paramServices = [];
                            if (widget.clientAppointment == null) {
                              for (var element
                                  in bookAppointmentController.addedServices) {
                                paramServices.add({
                                  "serviceId": element.services.serviceId,
                                  "BusinessServiceId":
                                      element.services.businessServiceId,
                                  "serviceName": element.services.serviceName,
                                  "serviceNameH": element.services.serviceNameH,
                                  "subServiceId": 0,
                                  "subServiceName": ""
                                });
                              }
                              for (var element in bookAppointmentController
                                  .addedSubServices) {
                                paramServices.add({
                                  "serviceId": element.services.serviceId,
                                  "BusinessServiceId":
                                      element.services.businessServiceId,
                                  "serviceName": element.services.serviceName,
                                  "serviceNameH": element.services.serviceNameH,
                                  "subServiceId":
                                      element.subService.subServiceId,
                                  "subServiceName":
                                      element.subService.subServiceName
                                });
                              }
                            } else {
                              for (var element in widget
                                  .clientAppointment!.appointmentService) {
                                paramServices.add({
                                  "serviceId": element.serviceId,
                                  "BusinessServiceId":
                                      element.businessServiceId,
                                  "serviceName": element.serviceName,
                                  "serviceNameH": element.serviceNameH,
                                  "subServiceId": element.isSubService
                                      ? element.subServiceId
                                      : 0,
                                  "subServiceName": element.isSubService
                                      ? element.subServiceName
                                      : ""
                                });
                              }
                            }
                            int stfId = 0;
                            int bsnId = 0;
                            if (widget.clientAppointment == null) {
                              stfId = seletedStaffId!;
                              bsnId = widget.businessId;
                            } else {
                              stfId = widget.clientAppointment!
                                  .appointmentService[0].staffId;
                              bsnId = widget.clientAppointment!
                                  .appointmentService[0].businessId;
                            }
                            bookAppointmentController
                                .getAvailbleSlotForStaff(
                                    bsnId, stfId, formatedDate, paramServices)
                                .then((value) {
                              hourIndex = -1;
                              selectedSlot = null;
                              if (value == 200) {
                                for (var element in bookAppointmentController
                                    .availableSlots) {
                                  int time = int.parse(
                                      element.fromWorkingHours.split(":")[0]);

                                  if (time < 12) {
                                    morningSlots.add(element);
                                  } else if (time < 16) {
                                    noonSlots.add(element);
                                  } else {
                                    evening.add(element);
                                  }
                                }
                                setState(() {});
                              } else {
                                selectedSlot = null;
                              }
                            });
                          } else {
                            selectedDate = null;
                            selectedSlot = null;
                            Fluttertoast.showToast(
                                msg: "Staff not available".tr);
                          }
                        } else {
                          selectedDate = null;
                          selectedSlot = null;
                          Fluttertoast.showToast(
                              msg: "Business have no working hours".tr);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: checkDAteEnableOrNot(datess[index])
                                ? Colors.white
                                : const Color.fromARGB(
                                    255,
                                    241,
                                    240,
                                    240,
                                  ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1.6,
                                color: dateIndex == index
                                    ? Colr.primary
                                    : Colors.transparent)),
                        height: 70,
                        width: 120,
                        padding: EdgeInsets.only(
                            left:
                                localizationController.isHebrew.value ? 0 : 20,
                            right:
                                localizationController.isHebrew.value ? 20 : 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommenTextWidget(
                              s: DateFormat(
                                      'EEEE dd',
                                      localizationController.isHebrew.value
                                          ? 'he'
                                          : 'en')
                                  .format(datess[index]),
                              fw: FontWeight.w600,
                            ),
                            CommenTextWidget(
                              s: DateFormat(
                                      'MMMM yyyy',
                                      localizationController.isHebrew.value
                                          ? 'he'
                                          : 'en')
                                  .format(datess[index]),
                              clr: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
              ),
      ],
    );
  }

  Future<void> getAvailableStaffForService() async {
    List<Map> serviceIdMap = [];
    for (int i = 0; i < bookAppointmentController.addedServices.length; i++) {
      serviceIdMap.add({
        "serviceId":
            bookAppointmentController.addedServices[i].services.serviceId
      });
    }
    for (int i = 0;
        i < bookAppointmentController.addedSubServices.length;
        i++) {
      if (checkServiceId(
          bookAppointmentController.addedSubServices[i].services.serviceId,
          serviceIdMap)) {
      } else {
        serviceIdMap.add({
          "serviceId":
              bookAppointmentController.addedSubServices[i].services.serviceId
        });
      }
    }
    await bookAppointmentController
        .getAvailableStaffForService(widget.businessId, serviceIdMap)
        .then((value) {
      if (value.isEmpty) {
        setState(() {
          isStaffLoad = false;
        });
      } else {
        getAvailbleDate(value[0].staffId);
        setState(() {
          staffList = value;
          seletedStaffId = staffList[0].staffId;
          isStaffLoad = false;
        });
      }
    });
  }

  bool checkDuplicate(StaffModel staffL) {
    for (int i = 0; i < staffList.length; i++) {
      if (staffList[i].staffId == staffL.staffId) {
        return true;
      }
    }
    return false;
  }

  Future<void> getAvailbleDate(int staffId) async {
    availableDates = [];
    List<AvailableDatesModel> apiStringDates = await bookAppointmentController
        .getAvailbleDatesForStaff(staffId, widget.businessId);
    apiDAtesForCheck = apiStringDates.map((e) => e).toList();
    for (var element in apiStringDates) {
      String fullDate =
          "${element.availableDate.substring(6, 10)}-${element.availableDate.substring(0, 2)}-${element.availableDate.substring(3, 5)}";

      DateTime convertedDate = DateTime.parse(fullDate);
      if (element.notAvailableDate == "AvailableDate") {
        availableDates.add(convertedDate);
      }
    }
    setState(() {});
  }

  void bookAppointment() {
    Map data = {
      "customerId": userController.custInfo.value.id,
      "BusinessId": widget.businessId,
      "AppointmentDate": selectedDate!.toIso8601String(),
      "ClientId": userController.custInfo.value.id,
      "ClientMobileNo": "",
      "TotalPrice": getTotalPrice(),
      "balance": getBalancePrice(),
      "discount": selectedPromoCode?.discountAmount ?? 0,
      "PromoCode": isPromoApplied ? selectedPromoCode!.promoCode : "",
      "PromoCodeId": isPromoApplied ? selectedPromoCode!.id : 0,
      "AppointmentStartTime": appointmentTime!.toIso8601String(),
      "serviceList": getServiceListData()
    };
    bookAppointmentController.bookAppointmentApi(data).then((value) async {
      setState(() {
        isBookButtonLoad = false;
      });
      if (value == null) {
        Fluttertoast.showToast(msg: "Failed to book appointment".tr);
      } else {
        String endTim = bookAppointmentController
            .appointmentSuccess.value.endTime!
            .toIso8601String()
            .replaceAll('Z', '');
        Get.to(() => Success(
              staTime: appointmentTime!,
              enTime: DateTime.parse(endTim),
            ));
        await notificationController
            .getAllNotifications(customerController.custInfo.value.id!)
            .then((value) {
          if (value == 200) {
            PushNotification().showNotifications(
                0,
                "Your Appointment has been Booked Successfully!!!".tr,
                notificationController
                    .notifications[
                        notificationController.notifications.length - 1]
                    .message,
                "AppointmentScreen");
          }
        });
      }
    });
  }

  getServiceListData() {
    List servicesData = [];

    for (int i = 0; i < bookAppointmentController.addedServices.length; i++) {
      servicesData.add({
        "BusinessId": widget.businessId,
        "serviceId":
            bookAppointmentController.addedServices[i].services.serviceId,
        "BusinessServiceId": bookAppointmentController
            .addedServices[i].services.businessServiceId,
        "SubServiceId": 0,
        "StaffId": seletedStaffId,
        "AppointmentDate": selectedDate!.toIso8601String(),
        "SubServiceName": "",
        "IsSubService": false,
        "AppointmentSlotId": selectedSlot!.workingHoursId,
        "TotalPrice": bookAppointmentController.addedServices[i].services.price
      });
    }
    for (int i = 0;
        i < bookAppointmentController.addedSubServices.length;
        i++) {
      servicesData.add({
        "BusinessId": widget.businessId,
        "serviceId":
            bookAppointmentController.addedSubServices[i].services.serviceId,
        "BusinessServiceId": bookAppointmentController
            .addedSubServices[i].services.businessServiceId,
        "SubServiceId": bookAppointmentController
            .addedSubServices[i].subService.subServiceId,
        "StaffId": seletedStaffId,
        "AppointmentDate": selectedDate!.toIso8601String(),
        "SubServiceName": bookAppointmentController
            .addedSubServices[i].subService.subServiceName,
        "IsSubService": true,
        "AppointmentSlotId": selectedSlot!.workingHoursId,
        "TotalPrice":
            bookAppointmentController.addedSubServices[i].subService.price
      });
    }
    return servicesData;
  }

  getTotalPrice() {
    num totalPrice = 0;
    for (var element in bookAppointmentController.addedServices) {
      totalPrice = totalPrice + element.services.price;
    }
    for (var element in bookAppointmentController.addedSubServices) {
      totalPrice = totalPrice + element.subService.price;
    }

    return totalPrice;
  }

  getBalancePrice() {
    num totalPrice = 0;
    for (var element in bookAppointmentController.addedServices) {
      totalPrice = totalPrice + element.services.price;
    }
    for (var element in bookAppointmentController.addedSubServices) {
      totalPrice = totalPrice + element.subService.price;
    }
    if (isPromoApplied) {
      totalPrice = totalPrice - selectedPromoCode!.discountAmount;
    }
    return totalPrice;
  }

  bool checkServiceId(int servId, List<Map> servieMapId) {
    List<Map> serviceIdMap = [];
    serviceIdMap = servieMapId;
    for (int i = 0; i < serviceIdMap.length; i++) {
      if (serviceIdMap[i]["serviceId"] == servId) {
        return true;
      }
    }
    return false;
  }

  getPromoCodeBottomSheet() {
    return StatefulBuilder(
      builder: (context, settState) {
        return Container(
            height: 400,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CommenTextWidget(
                  s: "Select Promo code".tr,
                  size: 20,
                  fw: FontWeight.w600,
                ),
                const Divider(),
                const SizedBox(
                  height: 30,
                ),
                Obx(() => bookAppointmentController.promoCodes.isEmpty
                    ? CommenTextWidget(s: "Promo code not available".tr)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommenTextWidget(
                            s: "${"Promo code".tr} :    ",
                            fw: FontWeight.w500,
                            size: 18,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black54, width: 1.2)),
                            height: 60,
                            width: 160,
                            child: Center(
                              child: SizedBox(
                                width: 140,
                                child: DropdownSearch<PromoCodeModel>(
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Select One".tr,
                                    ),
                                  ),
                                  items: List.generate(
                                      bookAppointmentController
                                          .promoCodes.length,
                                      (index) => bookAppointmentController
                                          .promoCodes[index]),
                                  selectedItem: selectedPromoCode,
                                  itemAsString: (PromoCodeModel u) =>
                                      u.promoCode,
                                  onChanged: (value) {
                                    settState(
                                      () {
                                        selectedPromoCode = value;
                                        isPromoSelcted = true;
                                      },
                                    );
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                const SizedBox(
                  height: 15,
                ),
                selectedPromoCode != null
                    ? Column(
                        children: [
                          CommenTextWidget(
                            s: "${"Description".tr} : ${selectedPromoCode!.description ?? ""}",
                            fw: FontWeight.w500,
                            size: 18,
                          ),
                          CommenTextWidget(
                            s: "${"Minimum order".tr} :${selectedPromoCode!.minimumOrder}",
                            fw: FontWeight.w500,
                            size: 18,
                          ),
                          CommenTextWidget(
                            s: "${"Total service price".tr} : ${getTotalPrice()}",
                            fw: FontWeight.w500,
                            size: 18,
                          ),
                          CommenTextWidget(
                            s: "${"Discount price".tr} :${selectedPromoCode!.discountAmount}",
                            fw: FontWeight.w500,
                            size: 18,
                          )
                        ],
                      )
                    : CommenTextWidget(
                        s: "${"Total service price".tr} : ${getTotalPrice()}",
                        fw: FontWeight.w500,
                        size: 18,
                      ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButtons(
                      text: "Cancel".tr,
                      backgroundColor: Colr.primary,
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 45,
                      width: Get.width * 0.4,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    AppButtons(
                      text: "Apply".tr,
                      backgroundColor: Colr.primary,
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 45,
                      width: Get.width * 0.4,
                      onPressed: () {
                        if (selectedPromoCode!.minimumOrder <=
                            getTotalPrice()) {
                          settState(
                            () {
                              isPromoApplied = true;
                            },
                          );
                          setState(() {});
                          Get.back();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Can't apply promo code".tr);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }

  getPromoCode() async {
    await bookAppointmentController.getPromoCode();
  }

  editServiceListWidget() {
    return Column(
        children: List.generate(
            widget.clientAppointment!.appointmentService.length, (index) {
      return Column(
        children: [
          ListTile(
            title: CommenTextWidget(
                s: localizationController.isHebrew.value
                    ? widget.clientAppointment!.appointmentService[index]
                        .serviceNameH
                    : widget.clientAppointment!.appointmentService[index]
                        .serviceName),
            trailing: CommenTextWidget(
              s: "${"NIS".tr} ${widget.clientAppointment!.appointmentService[index].price}",
              fw: FontWeight.w600,
              clr: Colors.black87,
            ),
          ),
          index != widget.clientAppointment!.appointmentService.length - 1
              ? const Divider(
                  thickness: 1.5,
                  endIndent: 20,
                  indent: 20,
                )
              : const SizedBox(
                  height: 10,
                )
        ],
      );
    }));
  }

  void editAppointment() {
    Map updateData = {
      "appointmentId": widget.clientAppointment!.appointmentId,
      "appointmentSlotId": selectedSlot!.workingHoursId,
      "appointmentDate": selectedDate!.toIso8601String(),
      "customerId": userController.custInfo.value.id
    };
    setState(() {
      isBookButtonLoad = true;
    });
    bookAppointmentController
        .editAppointmentApi(updateData, lat, long)
        .then((value) async {
      setState(() {
        isBookButtonLoad = false;
      });
      if (value == "") {
        Fluttertoast.showToast(msg: "Failed to edit appointment".tr);
      } else {
        Fluttertoast.showToast(msg: "Appointment updated successfully".tr);
        await notificationController
            .getAllNotifications(customerController.custInfo.value.id!)
            .then((value) {
          if (value == 200) {
            PushNotification().showNotifications(
                0,
                "Your Appointment has been Updated Successfully!!!".tr,
                notificationController
                    .notifications[
                        notificationController.notifications.length - 1]
                    .message,
                "AppointmentScreen");
          }
        });

        Get.back();
      }
    });
  }

  void getDateIndex() {
    dateIndex = datess.indexOf(widget.clientAppointment!.appointmentDate);
    setState(() {});
  }

  bool checkSalonEndTime(String timeHour, DateTime startt) {
    DateTime totalDuration = getTotalDuration(timeHour, startt);

    DateTime lastSlot = DateTime(
        startt.year,
        startt.month,
        startt.day,
        int.parse(bookAppointmentController
            .availableSlots[bookAppointmentController.availableSlots.length - 1]
            .fromWorkingHours
            .split(":")[0]),
        int.parse(bookAppointmentController
            .availableSlots[bookAppointmentController.availableSlots.length - 1]
            .fromWorkingHours
            .split(":")[1]));

    if (totalDuration.hour > lastSlot.hour) {
      return false;
    } else if (totalDuration.hour == lastSlot.hour) {
      if (totalDuration.minute > lastSlot.minute) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  DateTime getTotalDuration(String timeHour, DateTime startt) {
    DateTime totalDuration =
        DateTime(startt.year, startt.month, startt.day, 0, 0);

    totalDuration = totalDuration.add(Duration(
        hours: int.parse(timeHour.split(":")[0]),
        minutes: int.parse(timeHour.split(":")[1])));

    for (var element in bookAppointmentController.addedServices) {
      totalDuration =
          totalDuration.add(getTimeFormat(element.services.duration!));
    }
    for (var element in bookAppointmentController.addedSubServices) {
      totalDuration =
          totalDuration.add(getTimeFormat(element.subService.duration!));
    }
    int totalServLengh = bookAppointmentController.addedServices.length +
        bookAppointmentController.addedSubServices.length;
    for (int i = 1; i < totalServLengh; i++) {
      totalDuration = totalDuration.add(const Duration(minutes: 5));
    }
    return totalDuration;
  }

  getTimeFormat(String dte) {
    TimeOfDay endTime = dte.length > 4
        ? (dte.contains('min') && dte.contains('h'))
            ? TimeOfDay(
                hour: int.parse(dte.split("h")[0]),
                minute: int.parse(dte.split(" ")[1]))
            : (dte.contains('min'))
                ? TimeOfDay(hour: 0, minute: int.parse(dte.split(" ")[0]))
                : TimeOfDay(
                    hour: int.parse(dte.split("h")[0]),
                    minute: int.parse(dte.split(" ")[1]))
        : TimeOfDay(
            hour: int.parse(dte.split("h")[0]),
            minute: 0,
          );
    return Duration(hours: endTime.hour, minutes: endTime.minute);
  }

  bool getStaffAttendance(DateTime ckDate) {
    AvailableDatesModel selDate;
    String formateDAte = DateFormat("MM-dd-yyyy").format(ckDate);

    selDate = apiDAtesForCheck
        .where((element) => element.availableDate == formateDAte)
        .first;
    if (selDate.isStaffAvailable) {
      return true;
    } else {
      return false;
    }
  }

  checkSlotEnable(int iindex) {
    AvailableSlotModel choosenSLot = isMorning
        ? morningSlots[iindex]
        : isNoon
            ? noonSlots[iindex]
            : evening[iindex];
    DateTime bookLimted = DateTime.now();
    DateTime choosenTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(choosenSLot.fromWorkingHours.split(":")[0]),
        int.parse(choosenSLot.fromWorkingHours.split(":")[1]));
    if (selectedDate!.month == DateTime.now().month &&
        selectedDate!.day == DateTime.now().day &&
        selectedDate!.year == DateTime.now().year) {
      if (choosenSLot.bookingValue != 0) {
        bookLimted = bookLimted.add(Duration(hours: choosenSLot.bookingValue!));
        if (bookLimted.hour == choosenTime.hour) {
          if (bookLimted.minute < choosenTime.minute) {
            return true;
          } else {
            return false;
          }
        } else {
          if (bookLimted.hour < choosenTime.hour) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        if (choosenTime.hour > DateTime.now().hour) {
          return true;
        } else if (choosenTime.hour == DateTime.now().hour) {
          if (choosenTime.minute > DateTime.now().minute) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } else {
      return true;
    }
  }

  bool checkHoliday(DateTime choosenDate) {
    if (apiDAtesForCheck[0]
        .workinghourslist
        .contains(DateFormat("EEEE").format(choosenDate))) {
      return false;
    }
    return true;
  }

  beforeDAteCheck() {
    if (todayDummy.month == DateTime.now().month) {
      return true;
    }
    return false;
  }

  String? checkCustomAvailble(DateTime choosenDates) {
    AvailableDatesModel selDate;
    String formateDAte = DateFormat("MM-dd-yyyy").format(choosenDates);
    selDate = apiDAtesForCheck
        .where((element) => formateDAte == element.availableDate)
        .first;
    return selDate.isCustomWorkingHours;
  }

  bool checkDAteEnableOrNot(DateTime checkDates) {
    if (availableDates.contains(checkDates)) {
      if (checkCustomAvailble(checkDates) == "Available") {
        return true;
      } else if (checkCustomAvailble(checkDates) == "NotAvailable") {
        return false;
      } else if (checkHoliday(checkDates)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  afterMonthCheck() {
    if (availableDates.isEmpty) {
      return true;
    } else {
      int lastMonth = apiDAtesForCheck[apiDAtesForCheck.length - 1].month;
      if (lastMonth == todayDummy.month) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future getCurrentLocation() async {
    LocationData? currentLocation;
    enableBackgroundMode();

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {}
    }
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    if (serviceEnabled) {
      var location = Location();
      try {
        // Find and store your location in a variable
        currentLocation = await location.getLocation();
      } on Exception {
        currentLocation = null;
      }
      if (currentLocation != null) {
        lat = currentLocation.latitude!;
        long = currentLocation.longitude!;
      }
    }
  }

  Future<bool> enableBackgroundMode() async {
    bool bgModeEnabled = await location.isBackgroundModeEnabled();
    if (bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      return bgModeEnabled;
    }
  }

  checkServiceOverLapApi(DateTime endtt, DateTime statt) async {
    String url =
        "${apiurl.baseUrl}Profile/GetSelectedSlotsOverlap?StaffId=$seletedStaffId&businessId=${widget.businessId}&SelectedDate=${statt.toIso8601String()}&EndTime=${endtt.toIso8601String()}&IsCustomWorkingHours=$isCustomWorkingHours";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String result = response.body;
      overlapsMessage = result;
    } else {
      overlapsMessage = "";
    }
  }

  Future<void> onSlotClickEvent(int index) async {
    hourIndex = index;
    String hourString = isMorning
        ? morningSlots[index].fromWorkingHours
        : isNoon
            ? noonSlots[index].fromWorkingHours
            : evening[index].fromWorkingHours;
    DateTime startt = DateTime.parse(
        // ignore: prefer_interpolation_to_compose_strings
        selectedDate!.toIso8601String().substring(0, 11) +
            hourString +
            ":00.000");

    if (checkSalonEndTime(hourString, startt)) {
      if (checkSlotEnable(index)) {
        await checkServiceOverLapApi(
            getTotalDuration(hourString, startt), startt);

        if (overlapsMessage == "Success") {
          selectedSlot = isMorning
              ? morningSlots[index]
              : isNoon
                  ? noonSlots[index]
                  : evening[index];

          appointmentTime = DateTime.parse(
              // ignore: prefer_interpolation_to_compose_strings
              selectedDate!.toIso8601String().substring(0, 11) +
                  hourString +
                  ":00.000");
        } else if (overlapsMessage == "breaktime overlap") {
          selectedSlot = null;
          Fluttertoast.showToast(
              msg: "Service Overlaps With Staff BreakTime".tr);
        } else if (overlapsMessage == "servicetime overlap") {
          selectedSlot = null;
          Fluttertoast.showToast(
              msg: "Staff Service overlaps with other service".tr);
        } else {}
      } else {
        selectedSlot = null;
        Fluttertoast.showToast(msg: "Slot not Available".tr);
      }
    } else {
      selectedSlot = null;
      Fluttertoast.showToast(
          msg: "Service Time Exceeds Salon Working Hours".tr);
    }
    setState(() {});
  }
}

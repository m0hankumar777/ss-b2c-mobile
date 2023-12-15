// ignore_for_file: file_names

import 'package:B2C/controller/appointmentlist_controller.dart';
import 'package:B2C/controller/homescreen_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/main.dart';
import 'package:B2C/model/appointment_list_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/utility/widget_helper/common_elevated_button.dart';
import 'package:B2C/view/screens/BookAppointment/select_staff_and_timing_screen.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: library_prefixes
import 'package:B2C/controller/login_controller.dart' as loginAuth;
import 'package:location/location.dart';

// ignore: must_be_immutable
class AppointmentsList extends StatefulWidget {
  const AppointmentsList({super.key});

  @override
  State<AppointmentsList> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  Location location = Location();

  bool isLoad = false;
  final appointmentListController = Get.put(AppointmentListController());
  final localizationController = Get.put(LocalizationController());
  final customerController = Get.put(CustomerController());
  final notificationController = Get.put(HomeScreenController());

  bool isLogin = loginAuth.getLoginStatus();
  Future<void>? launched;
  RxBool isGpsEnabled = true.obs;
  double lati = 0.0;
  double longi = 0.0;

  @override
  void initState() {
    super.initState();
    appointmentListController.appointmentData.value =
        PastFutureAppointmentsModel();
    setState(() {
      isLoad = true;
    });
    fetchAPI();
  }

  Future<void> fetchAPI() async {
    if (isLogin) {
      customerController.getUserInformation();
    }
    await appointmentListController.getAppointnentsData(
        customerController.custInfo.value.id!, lati, longi);
    getCurrentLocation().then((value) async =>
        await appointmentListController.getAppointnentsData(
            customerController.custInfo.value.id!, lati, longi));
    if (mounted) {
      setState(() {
        isLoad = false;
      });
    }
    await getAppointmentCount();
  }

  @override
  void dispose() {
    super.dispose();
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
        lati = currentLocation.latitude!;
        longi = currentLocation.longitude!;
      }
    }
  }

  Future<void> getAppointmentCount() async {
    await appointmentListController
        .getFutureAppointmentCountList(customerController.custInfo.value.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CommenTextWidget(
          s: 'My Appointments'.tr,
          clr: Colors.black,
          size: 18,
          fw: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLogin
          ? isLoad
              ? Center(child: CircularProgressIndicator(color: Colr.primary))
              : DefaultTabController(
                  length: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.0, vertical: 5),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          child: TabBar(
                            tabs: [
                              CommenTextWidget(
                                s: 'Future'.tr,
                                size: 15,
                                fw: FontWeight.w400,
                              ),
                              CommenTextWidget(
                                s: 'Previous'.tr,
                                size: 15,
                                fw: FontWeight.w400,
                              ),
                            ],
                            indicator: ContainerTabIndicator(
                                radius: const BorderRadius.all(
                                    Radius.circular(7.0)),
                                padding: const EdgeInsets.all(8.0),
                                color: Colr.primary),
                            unselectedLabelColor: Colr.secondaryGrey,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              getFutureAppointmentList(context),
                              getPreviousAppointmentList(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          : Center(
              child: CommenTextWidget(
                s: 'Please Login to see your appointments'.tr,
                clr: Colr.primary,
                size: 15,
              ),
            ),
    );
  }

  getPreviousAppointmentList(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: isLoad
              ? Center(child: CircularProgressIndicator(color: Colr.primary))
              : appointmentListController
                              .appointmentData.value.clientPastAppointments ==
                          null ||
                      appointmentListController
                          .appointmentData.value.clientPastAppointments!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Container(
                          height: Get.height * 0.108,
                          width: Get.width * 0.445,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(),
                            image: DecorationImage(
                                image: AssetImage('assets/images/Search1.png'),
                                opacity: 1.0,
                                fit: BoxFit.fill,
                                scale: 1.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(Get.width * 0.07),
                          child: Center(
                            child: CommenTextWidget(
                              s: 'No Appointments Found'.tr,
                              size: 15,
                              fs: FontStyle.normal,
                              fw: FontWeight.w700,
                              clr: Colr.primary,
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: List.generate(
                          appointmentListController.appointmentData.value
                              .clientPastAppointments!.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 3),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Get.width * 0.17,
                                      height: Get.width * 0.17,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: appointmentListController
                                                      .appointmentData
                                                      .value
                                                      .clientPastAppointments![
                                                          index]
                                                      .logo !=
                                                  null
                                              ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      appointmentListController
                                                              .appointmentData
                                                              .value
                                                              .clientPastAppointments![
                                                                  index]
                                                              .logo ??
                                                          ''))
                                              : const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage("assets/images/glamz-logo.png"))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommenTextWidget(
                                              s: appointmentListController
                                                          .appointmentData
                                                          .value
                                                          .clientPastAppointments![
                                                              index]
                                                          .businessUserName !=
                                                      null
                                                  ? appointmentListController
                                                          .appointmentData
                                                          .value
                                                          .clientPastAppointments![
                                                              index]
                                                          .businessUserName ??
                                                      ''
                                                  : '',
                                              fw: FontWeight.w700,
                                              ts: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.59,
                                              child: pastAddressField(
                                                  context, index),
                                            ),
                                          ]),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5),
                                  child: Divider(
                                    height: 1,
                                    thickness: 0.5,
                                  ),
                                ),
                                servicDetailList(
                                  'Service'.tr,
                                  appointmentListController
                                          .appointmentData
                                          .value
                                          .clientPastAppointments![index]
                                          .appointmentService
                                          .isNotEmpty
                                      ? localizationController.isHebrew.value
                                          ? appointmentListController
                                              .appointmentData
                                              .value
                                              .clientPastAppointments![index]
                                              .appointmentService[0]
                                              .serviceNameH
                                          : appointmentListController
                                              .appointmentData
                                              .value
                                              .clientPastAppointments![index]
                                              .appointmentService[0]
                                              .serviceName
                                      : '-',
                                ),
                                servicDetailList(
                                    'Date'.tr,
                                    appointmentListController.appointmentData
                                                .value.clientPastAppointments !=
                                            null
                                        ? DateFormat(
                                                "EEEE, dd MMMM, yyyy",
                                                localizationController
                                                        .isHebrew.value
                                                    ? 'he'
                                                    : 'en')
                                            .format(appointmentListController
                                                .appointmentData
                                                .value
                                                .clientPastAppointments![index]
                                                .appointmentDate)
                                        : '',
                                    clr: Colr.primary),
                                servicDetailList(
                                    'Hours'.tr,
                                    localizationController.isHebrew.value
                                        ? appointmentListController
                                                .appointmentData
                                                .value
                                                .clientPastAppointments![index]
                                                .appointmentService
                                                .isNotEmpty
                                            ? '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![index].appointmentService[0].endTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![index].appointmentService[0].startTime)}'
                                            : '-'
                                        : appointmentListController
                                                .appointmentData
                                                .value
                                                .clientPastAppointments![index]
                                                .appointmentService
                                                .isNotEmpty
                                            ? '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![index].appointmentService[0].startTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![index].appointmentService[0].endTime)}'
                                            : '-',
                                    clr: Colr.primary),
                                servicDetailList(
                                    'Cost'.tr,
                                    appointmentListController.appointmentData
                                                .value.clientPastAppointments !=
                                            null
                                        ? '${'NIS'.tr} ${appointmentListController.appointmentData.value.clientPastAppointments![index].total}'
                                        : '',
                                    clr: Colr.primary),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7.0, top: 15, right: 7, bottom: 7),
                                  child: AppButtons(
                                    onPressed: () => showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: Get.height * 0.7,
                                          width: double.infinity,
                                          child: StatefulBuilder(
                                            builder: (context, set) {
                                              return getPastAppointmentDetail(
                                                  context, index);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    height: 43,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    backgroundColor: Colors.grey.shade200,
                                    text: 'Details'.tr,
                                    textColor: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
        ));
  }

  getFutureAppointmentList(BuildContext context) {
    // print(
    //     'lat ${appointmentListController.appointmentData.value.clientFutureAppointments![0].latitude}');
    // print(
    //     'lon ${appointmentListController.appointmentData.value.clientFutureAppointments![0].longitude}');
    return Obx(() => SingleChildScrollView(
          child: isLoad
              ? Center(child: CircularProgressIndicator(color: Colr.primary))
              : appointmentListController
                              .appointmentData.value.clientFutureAppointments ==
                          null ||
                      appointmentListController.appointmentData.value
                          .clientFutureAppointments!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Container(
                          height: Get.height * 0.108,
                          width: Get.width * 0.445,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(),
                            image: DecorationImage(
                                image: AssetImage('assets/images/Search1.png'),
                                opacity: 1.0,
                                fit: BoxFit.fill,
                                scale: 1.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(Get.width * 0.07),
                          child: Center(
                            child: CommenTextWidget(
                              s: 'No Appointments Found'.tr,
                              size: 15,
                              fs: FontStyle.normal,
                              fw: FontWeight.w700,
                              clr: Colr.primary,
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: List.generate(
                          appointmentListController.appointmentData.value
                              .clientFutureAppointments!.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 3),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Get.width * 0.17,
                                      height: Get.width * 0.17,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: appointmentListController
                                                      .appointmentData
                                                      .value
                                                      .clientFutureAppointments![
                                                          index]
                                                      .logo !=
                                                  null
                                              ? DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      appointmentListController
                                                              .appointmentData
                                                              .value
                                                              .clientFutureAppointments![
                                                                  index]
                                                              .logo ??
                                                          ''))
                                              : const DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage("assets/images/glamz-logo.png"))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommenTextWidget(
                                              s: appointmentListController
                                                          .appointmentData
                                                          .value
                                                          .clientFutureAppointments![
                                                              index]
                                                          .businessUserName !=
                                                      null
                                                  ? appointmentListController
                                                          .appointmentData
                                                          .value
                                                          .clientFutureAppointments![
                                                              index]
                                                          .businessUserName ??
                                                      ''
                                                  : '',
                                              fw: FontWeight.w700,
                                              ts: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.59,
                                              child: futureAddressField(
                                                  context, index),
                                            ),
                                          ]),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5),
                                  child: Divider(
                                    height: 1,
                                    thickness: 0.5,
                                  ),
                                ),
                                servicDetailList(
                                  'Service'.tr,
                                  appointmentListController
                                          .appointmentData
                                          .value
                                          .clientFutureAppointments![index]
                                          .appointmentService
                                          .isNotEmpty
                                      ? localizationController.isHebrew.value
                                          ? appointmentListController
                                              .appointmentData
                                              .value
                                              .clientFutureAppointments![index]
                                              .appointmentService[0]
                                              .serviceNameH
                                          : appointmentListController
                                              .appointmentData
                                              .value
                                              .clientFutureAppointments![index]
                                              .appointmentService[0]
                                              .serviceName
                                      : '-',
                                ),
                                servicDetailList(
                                    'Date'.tr,
                                    appointmentListController
                                                .appointmentData
                                                .value
                                                .clientFutureAppointments !=
                                            null
                                        ? DateFormat(
                                                 "EEEE, dd MMMM, yyyy",
                                                localizationController
                                                        .isHebrew.value
                                                    ? 'he'
                                                    : 'en')
                                            .format(appointmentListController
                                                .appointmentData
                                                .value
                                                .clientFutureAppointments![
                                                    index]
                                                .appointmentDate)
                                        : '',
                                    clr: Colr.primary),
                                servicDetailList(
                                    'Hours'.tr,
                                    localizationController.isHebrew.value
                                        ? appointmentListController
                                                .appointmentData
                                                .value
                                                .clientFutureAppointments![
                                                    index]
                                                .appointmentService
                                                .isNotEmpty
                                            ? '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![index].appointmentService[0].endTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![index].appointmentService[0].startTime)}'
                                            : ''
                                        : appointmentListController
                                                .appointmentData
                                                .value
                                                .clientFutureAppointments![
                                                    index]
                                                .appointmentService
                                                .isNotEmpty
                                            ? '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![index].appointmentService[0].startTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![index].appointmentService[0].endTime)}'
                                            : '',
                                    clr: Colr.primary),
                                servicDetailList(
                                    'Cost'.tr,
                                    appointmentListController
                                                .appointmentData
                                                .value
                                                .clientFutureAppointments !=
                                            null
                                        ? '${'NIS'.tr} ${appointmentListController.appointmentData.value.clientFutureAppointments![index].total}'
                                        : '',
                                    clr: Colr.primary),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7.0, top: 15, right: 7, bottom: 7),
                                  child: AppButtons(
                                    onPressed: () => showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: Get.height * 0.7,
                                          width: double.infinity,
                                          child: StatefulBuilder(
                                            builder: (context, set) {
                                              return getFutureAppointmentDetail(
                                                  context, index);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    height: 43,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    backgroundColor: Colors.grey.shade200,
                                    text: 'Details'.tr,
                                    textColor: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
        ));
  }

  getPastAppointmentDetail(BuildContext context, int v) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width * 0.17,
                      height: Get.width * 0.17,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          image: appointmentListController.appointmentData.value
                                      .clientPastAppointments![v].logo !=
                                  null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(appointmentListController
                                          .appointmentData
                                          .value
                                          .clientPastAppointments![v]
                                          .logo ??
                                      ''))
                              : const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/glamz-logo.png"))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommenTextWidget(
                              s: appointmentListController
                                          .appointmentData
                                          .value
                                          .clientPastAppointments![v]
                                          .businessUserName !=
                                      null
                                  ? appointmentListController
                                          .appointmentData
                                          .value
                                          .clientPastAppointments![v]
                                          .businessUserName ??
                                      ''
                                  : '',
                              fw: FontWeight.w700,
                              ts: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: Get.width * 0.67,
                              child: pastAddressField(context, v),
                            ),
                          ]),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: Divider(
                    height: 3,
                    thickness: 0.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CommenTextWidget(
                          s: 'Address'.tr,
                          fw: FontWeight.w400,
                          size: 14,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: Get.width * 0.25,
                              child: CommenTextWidget(
                                s: appointmentListController
                                    .appointmentData
                                    .value
                                    .clientPastAppointments![v]
                                    .businessUserAddress
                                    .toString(),
                                of: TextOverflow.ellipsis,
                                sw: true,
                                mxL: 7,
                                fw: FontWeight.w700,
                                size: 14,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: AppButtons(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.17,
                                textColor: Colors.black,
                                text: "Navigation".tr,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(211, 51, 69, 0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: () => MapsLauncher.launchQuery(
                                    appointmentListController
                                        .appointmentData
                                        .value
                                        .clientPastAppointments![v]
                                        .businessUserAddress
                                        .toString()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CommenTextWidget(
                          s: 'Phone Number'.tr,
                          fw: FontWeight.w400,
                          size: 14,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: CommenTextWidget(
                                s: appointmentListController
                                    .appointmentData
                                    .value
                                    .clientPastAppointments![v]
                                    .businessUserMobile
                                    .toString(),
                                fw: FontWeight.w700,
                                size: 15,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: AppButtons(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  textColor: Colors.black,
                                  text: "Dialing".tr,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(211, 51, 69, 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      launched = _makePhoneCall(
                                          appointmentListController
                                              .appointmentData
                                              .value
                                              .clientPastAppointments![v]
                                              .businessUserMobile
                                              .toString());
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      appointmentListController
                          .appointmentData
                          .value
                          .clientPastAppointments![v]
                          .appointmentService
                          .length, (i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10),
                          child: Divider(height: 1, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 12),
                          child: CommenTextWidget(
                            s: 'Appointment Details'.tr,
                            align: TextAlign.start,
                            size: 18,
                            fw: FontWeight.w700,
                          ),
                        ),
                        servicDetailList(
                            'Service'.tr,
                            localizationController.isHebrew.value
                                ? appointmentListController
                                    .appointmentData
                                    .value
                                    .clientPastAppointments![v]
                                    .appointmentService[i]
                                    .serviceNameH
                                    .toString()
                                : appointmentListController
                                    .appointmentData
                                    .value
                                    .clientPastAppointments![v]
                                    .appointmentService[i]
                                    .serviceName
                                    .toString(),
                            fw: FontWeight.bold),
                        servicDetailList(
                            localizationController.isHebrew.value
                                ? 'crewMember'.tr
                                : 'Staff'.tr,
                            appointmentListController
                                .appointmentData
                                .value
                                .clientPastAppointments![v]
                                .appointmentService[i]
                                .staffName
                                .toString(),
                            fw: FontWeight.bold),
                        servicDetailList(
                            "Date".tr,
                            DateFormat(
                                    "EEEE, MMMM dd, yyyy",
                                    localizationController.isHebrew.value
                                        ? 'he'
                                        : 'en')
                                .format(appointmentListController
                                    .appointmentData
                                    .value
                                    .clientPastAppointments![v]
                                    .appointmentDate),
                            fw: FontWeight.bold,
                            clr: Colr.primary),
                        servicDetailList(
                            'Hours'.tr,
                            localizationController.isHebrew.value
                                ? '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![v].appointmentService[i].endTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![v].appointmentService[i].startTime)}'
                                : '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![v].appointmentService[i].startTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientPastAppointments![v].appointmentService[i].endTime)}',
                            fw: FontWeight.bold,
                            clr: Colr.primary),
                        servicDetailList('Cost'.tr,
                            '${'NIS'.tr} ${appointmentListController.appointmentData.value.clientPastAppointments![v].appointmentService[i].price}',
                            fw: FontWeight.bold, clr: Colr.primary),
                        Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: appointmentListController
                                        .appointmentData
                                        .value
                                        .clientPastAppointments![v]
                                        .status !=
                                    0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colr.primary,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: CommenTextWidget(
                                            s: appointmentListController
                                                        .appointmentData
                                                        .value
                                                        .clientPastAppointments![
                                                            v]
                                                        .status ==
                                                    5
                                                ? 'Cancelled Appointment'.tr
                                                : appointmentListController
                                                            .appointmentData
                                                            .value
                                                            .clientPastAppointments![
                                                                v]
                                                            .status ==
                                                        4
                                                    ? 'No Shows'.tr
                                                    : appointmentListController
                                                                .appointmentData
                                                                .value
                                                                .clientPastAppointments![
                                                                    v]
                                                                .status ==
                                                            3
                                                        ? 'Completed'.tr
                                                        : 'Booked'.tr,
                                            fw: FontWeight.w400,
                                            size: 14,
                                            clr: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ));
  }

  Future<dynamic> changeDatebottomSheet(
      BuildContext context, ClientAppointment appoint) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: Get.height * .45,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffBFC6D1),
                          borderRadius: BorderRadius.circular(5)),
                      height: Get.height * .005,
                      width: Get.width * .1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CommenTextWidget(
                  size: 15,
                  s: 'Change of date'.tr,
                  fw: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                CommenTextWidget(
                    // ignore: prefer_interpolation_to_compose_strings
                    s: 'Are you sure you want to change the appointment to '
                            .tr +
                        appoint.businessUserName! +
                        '? Changing the appointment may cancel the existing appointment!'
                            .tr),
                SizedBox(
                  height: Get.height * .03,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(SelectStaffAndTimingScreen(
                      businessId: appoint.appointmentService[0].businessId,
                      clientAppointment: appoint,
                    ));
                  },
                  child: Container(
                    height: Get.height * .08,
                    decoration: BoxDecoration(
                        color: const Color(0xffF6D6DA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: CommenTextWidget(
                      s: "Change of date".tr,
                      size: 15,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: Get.height * .08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: CommenTextWidget(
                      s: "Don't Change".tr,
                      size: 15,
                    )),
                  ),
                ),
                SizedBox(height: Get.height * .04),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  getFutureAppointmentDetail(BuildContext context, int v) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width * 0.17,
                      height: Get.width * 0.17,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          image: appointmentListController.appointmentData.value
                                      .clientFutureAppointments![v].logo !=
                                  null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(appointmentListController
                                          .appointmentData
                                          .value
                                          .clientFutureAppointments![v]
                                          .logo ??
                                      ''))
                              : const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/glamz-logo.png"))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommenTextWidget(
                              s: appointmentListController
                                          .appointmentData
                                          .value
                                          .clientFutureAppointments![v]
                                          .businessUserName !=
                                      null
                                  ? appointmentListController
                                          .appointmentData
                                          .value
                                          .clientFutureAppointments![v]
                                          .businessUserName ??
                                      ''
                                  : '',
                              fw: FontWeight.w700,
                              ts: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: Get.width * 0.6,
                              child: futureAddressField(context, v),
                            ),
                          ]),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: Divider(
                    height: 3,
                    thickness: 0.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CommenTextWidget(s: 'Address'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: Get.width * 0.3,
                              child: CommenTextWidget(
                                s: appointmentListController
                                    .appointmentData
                                    .value
                                    .clientFutureAppointments![v]
                                    .businessUserAddress
                                    .toString(),
                                fw: FontWeight.bold,
                                of: TextOverflow.ellipsis,
                                sw: true,
                                mxL: 7,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: AppButtons(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.17,
                                textColor: Colors.black,
                                text: "Navigation".tr,
                                fontSize: 10,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(211, 51, 69, 0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: () => MapsLauncher.launchQuery(
                                    appointmentListController
                                        .appointmentData
                                        .value
                                        .clientFutureAppointments![v]
                                        .businessUserAddress
                                        .toString()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: CommenTextWidget(s: 'Phone Number'.tr),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: CommenTextWidget(
                                s: appointmentListController
                                    .appointmentData
                                    .value
                                    .clientFutureAppointments![v]
                                    .businessUserMobile
                                    .toString(),
                                fw: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: AppButtons(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  textColor: Colors.black,
                                  text: "Dialing".tr,
                                  fontSize: 10,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(211, 51, 69, 0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      launched = _makePhoneCall(
                                          appointmentListController
                                              .appointmentData
                                              .value
                                              .clientFutureAppointments![v]
                                              .businessUserMobile
                                              .toString());
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      appointmentListController
                          .appointmentData
                          .value
                          .clientFutureAppointments![v]
                          .appointmentService
                          .length, (i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 10),
                          child: Divider(height: 1, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 12),
                          child: CommenTextWidget(
                            s: 'Appointment Details'.tr,
                            align: TextAlign.start,
                            size: 16,
                            fw: FontWeight.bold,
                          ),
                        ),
                        servicDetailList(
                            'Service'.tr,
                            appointmentListController
                                    .appointmentData
                                    .value
                                    .clientFutureAppointments![v]
                                    .appointmentService
                                    .isNotEmpty
                                ? localizationController.isHebrew.value
                                    ? appointmentListController
                                        .appointmentData
                                        .value
                                        .clientFutureAppointments![v]
                                        .appointmentService[i]
                                        .serviceNameH
                                    : appointmentListController
                                        .appointmentData
                                        .value
                                        .clientFutureAppointments![v]
                                        .appointmentService[i]
                                        .serviceName
                                : '-',
                            fw: FontWeight.bold),
                        servicDetailList(
                            localizationController.isHebrew.value
                                ? 'crewMember'.tr
                                : 'Staff'.tr,
                            appointmentListController
                                .appointmentData
                                .value
                                .clientFutureAppointments![v]
                                .appointmentService[i]
                                .staffName
                                .toString(),
                            fw: FontWeight.bold),
                        servicDetailList(
                            'Date'.tr,
                            DateFormat(
                                    "EEEE, MMMM dd, yyyy",
                                    localizationController.isHebrew.value
                                        ? 'he'
                                        : 'en')
                                .format(appointmentListController
                                    .appointmentData
                                    .value
                                    .clientFutureAppointments![v]
                                    .appointmentDate),
                            fw: FontWeight.bold,
                            clr: Colr.primary),
                        servicDetailList(
                            'Hours'.tr,
                            localizationController.isHebrew.value
                                ? '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![v].appointmentService[i].endTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![v].appointmentService[i].startTime)}'
                                : '${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![v].appointmentService[i].startTime)} - ${DateFormat.Hm().format(appointmentListController.appointmentData.value.clientFutureAppointments![v].appointmentService[i].endTime)}',
                            fw: FontWeight.bold,
                            clr: Colr.primary),
                        servicDetailList('Cost'.tr,
                            '${'NIS'.tr} ${appointmentListController.appointmentData.value.clientFutureAppointments![v].appointmentService[i].price}',
                            fw: FontWeight.bold, clr: Colr.primary),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: appointmentListController.appointmentData.value
                                      .clientFutureAppointments![v].status !=
                                  1
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colr.primary,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: CommenTextWidget(
                                            s: appointmentListController
                                                        .appointmentData
                                                        .value
                                                        .clientFutureAppointments![
                                                            v]
                                                        .status ==
                                                    5
                                                ? 'Cancelled Appointment'.tr
                                                : appointmentListController
                                                            .appointmentData
                                                            .value
                                                            .clientFutureAppointments![
                                                                v]
                                                            .status ==
                                                        3
                                                    ? 'Completed'.tr
                                                    : 'No Shows'.tr,
                                            clr: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0, vertical: 5),
                                      child: AppButtons(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          cancelAppointmentBottomSheet(
                                              context,
                                              appointmentListController
                                                  .appointmentData
                                                  .value
                                                  .clientFutureAppointments![v]
                                                  .appointmentId);
                                        },
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        backgroundColor: const Color.fromRGBO(
                                            211, 51, 69, 0.2),
                                        text: 'Canceling an appointment'.tr,
                                        textColor: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0, vertical: 5),
                                      child: AppButtons(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          changeDatebottomSheet(
                                              context,
                                              appointmentListController
                                                  .appointmentData
                                                  .value
                                                  .clientFutureAppointments![v]);
                                        },
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        backgroundColor: const Color.fromRGBO(
                                            211, 51, 69, 0.2),
                                        text: 'Change of date'.tr,
                                        textColor: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ));
  }

  Future<dynamic> cancelAppointmentBottomSheet(
      BuildContext context, int appointmentId) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: Get.height * .45,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffBFC6D1),
                          borderRadius: BorderRadius.circular(5)),
                      height: Get.height * .005,
                      width: Get.width * .1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CommenTextWidget(
                  size: 15,
                  s: 'Canceling an appointment'.tr,
                  fw: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                CommenTextWidget(
                    s: "Are you sure you want to cancel the appointment".tr),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    getAppointmentCount();

                    await appointmentListController
                        .cancelAppointment(appointmentId,
                            customerController.custInfo.value.id!)
                        .then((value) async {
                      if (value == 200) {
                        appointmentListController.getAppointnentsData(
                            customerController.custInfo.value.id!, lati, longi);
                        Fluttertoast.showToast(
                            msg: 'Appointment cancelled successfully'.tr);
                        await notificationController
                            .getAllNotifications(
                                customerController.custInfo.value.id!)
                            .then((value) {
                          if (value == 200) {
                            PushNotification().showNotifications(
                                0,
                                "Your Appointment has been Cancelled Successfully!!!"
                                    .tr,
                                notificationController
                                    .notifications[notificationController
                                            .notifications.length -
                                        1]
                                    .message,
                                "AppointmentScreen");
                          }
                        });

                        Get.back();
                      } else {
                        Fluttertoast.showToast(msg: 'Internal server Error'.tr);
                      }
                    });
                  },
                  child: Container(
                    height: Get.height * .08,
                    decoration: BoxDecoration(
                        color: const Color(0xffF6D6DA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: CommenTextWidget(
                      s: "Cancel the Appointment".tr,
                      size: 15,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: Get.height * .08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: CommenTextWidget(
                      s: "Don't Cancel".tr,
                      size: 15,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row pastAddressField(BuildContext context, int pv) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Get.width * 0.35,
          child: CommenTextWidget(
            s: appointmentListController.appointmentData.value
                        .clientPastAppointments![pv].businessUserAddress !=
                    null
                ? appointmentListController.appointmentData.value
                    .clientPastAppointments![pv].businessUserAddress
                    .toString()
                : '',
            fw: FontWeight.w400,
            ts: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
            of: TextOverflow.ellipsis,
            mxL: 2,
          ),
        ),
        CommenTextWidget(
            s: '${appointmentListController.appointmentData.value.clientPastAppointments![pv].distance} ${'Km'.tr}',
            align: TextAlign.left,
            clr: Colors.black54,
            size: 14,
            fw: FontWeight.w300),
      ],
    );
  }

  Row futureAddressField(BuildContext context, int fv) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: CommenTextWidget(
            s: appointmentListController.appointmentData.value
                        .clientFutureAppointments?[fv].businessUserAddress !=
                    null
                ? appointmentListController.appointmentData.value
                    .clientFutureAppointments![fv].businessUserAddress
                    .toString()
                : '',
            mxL: 2,
            sw: true,
            of: TextOverflow.ellipsis,
            fw: FontWeight.w400,
            ts: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ),
        CommenTextWidget(
            s: '${appointmentListController.appointmentData.value.clientFutureAppointments![fv].distance} ${'Km'.tr}',
            align: TextAlign.left,
            clr: Colors.black54,
            size: 14,
            fw: FontWeight.w300),
      ],
    );
  }

  servicDetailList(String title, String value, {FontWeight? fw, Color? clr}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 35,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Container(
                alignment: localizationController.isHebrew.value
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                width: MediaQuery.of(context).size.width * 0.5,
                child: CommenTextWidget(
                  s: title,
                  sw: true,
                  of: TextOverflow.ellipsis,
                  ts: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  alignment: localizationController.isHebrew.value
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: CommenTextWidget(
                    s: value,
                    clr: clr ?? Colors.black,
                    fw: fw ?? FontWeight.w400,
                    ts: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

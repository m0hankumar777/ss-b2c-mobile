import 'package:B2C/controller/appointmentlist_controller.dart';
import 'package:B2C/controller/homescreen_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/view/screens/Appointments/appointments_list.dart';
import 'package:B2C/view/screens/HomeScreen/notifications_screen.dart';
import 'package:B2C/view/screens/MenuScreens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:B2C/controller/login_controller.dart' as loginauth;

import '../../../controller/bottom_navigationbar_controller.dart';
import '../../../controller/customer_controller.dart';
import '../../../utility/themes_b2c.dart';
import '../ProfileScreens/profile_screen.dart';
import 'ss_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  int selectedIndex;
  bool? isQues;
  int? businessId;
  HomeScreen({
    super.key,
    required this.selectedIndex,
    this.isQues,
    this.businessId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bottomNavigationBarController =
      Get.put(BottomNavigationBarController());
  final notificationsController = Get.put(HomeScreenController());
  final appointmentListController = Get.put(AppointmentListController());

  final customerController = Get.put(CustomerController());
  final locale = Get.put(LocalizationController());
  bool isLogin = loginauth.getLoginStatus();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    if (widget.isQues == true) {
      await bottomNavigationBarController.quesIndex(widget.selectedIndex);
    } else {
      bottomNavigationBarController.pageIndex(widget.selectedIndex);
    }
    if (isLogin) {
      await customerController.getUserInformation();
    }

    if (customerController.custInfo.value.id != null) {
      await notificationsController
          .getUnreadNotificationsCount(customerController.custInfo.value.id!);
      await appointmentListController
          .getFutureAppointmentCountList(customerController.custInfo.value.id!);
    }
    // getAccess();
  }

  /*  Future getAccess() async {
    if (Platform.isIOS) {
      TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      if (status == TrackingStatus.denied) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
        if (status == TrackingStatus.denied) {}
      }
    }
  } */

  @override
  Widget build(BuildContext context) {
    final List screens = [
      ProfileScreen(businessId: widget.businessId),
      const AppointmentsList(),
      const GlamzScreen(),
    ];
    return Obx(() => Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_circle_rounded),
                  label: 'Profile'.tr,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                    icon: (isLogin &&
                            // ignore: unrelated_type_equality_checks
                            appointmentListController.appointmentListCount !=
                                '0')
                        ? Stack(
                            children: <Widget>[
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 24,
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colr.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: Obx(() => Center(
                                        child: Text(
                                          appointmentListController
                                              .appointmentListCount
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          )
                        : const Icon(Icons.calendar_month_outlined),
                    label: 'My Appointments'.tr,
                    backgroundColor: Colors.white),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_rounded),
                    label: 'Glamz',
                    backgroundColor: Colors.white),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: widget.selectedIndex,
              showUnselectedLabels: true,
              selectedItemColor: Colr.primary,
              unselectedItemColor: Colors.grey,
              iconSize: 25,
              onTap: (index) {
                setState(() {
                  widget.selectedIndex = index;
                  bottomNavigationBarController.queIndex.value = 2;
                });
                bottomNavigationBarController.changeIndex(index);
              },
              elevation: 5),
        ),
        appBar: bottomNavigationBarController.queIndex.value == 1
            ? null
            : bottomNavigationBarController.pageIndex.value == 2
                ? AppBar(
                    shadowColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    backgroundColor:
                        Colr.primary, //Color.fromARGB(255, 248, 35, 20),
                    elevation: 0,
                    centerTitle: true,
                    title: const Text(
                      'Glamz',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    leading: getBreadGrumMenu(),
                    actions: [getNotificationIcon()],
                  )
                : null,
        body: screens[widget.selectedIndex]));
  }

  getBreadGrumMenu() {
    return InkWell(
      onTap: () {
        Get.to(const MenuScreen());
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: locale.isHebrew.value ? 10 : 20,
            top: 20,
            right: locale.isHebrew.value ? 20 : 0),
        child: SizedBox(
          height: 20,
          width: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: locale.isHebrew.value
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                width: 22,
                height: 1.5,
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                color: Colors.white,
                width: 17,
                height: 1.5,
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                color: Colors.white,
                width: 13,
                height: 1.5,
              )
            ],
          ),
        ),
      ),
    );
  }

  getNotificationIcon() {
    return Stack(children: [
      InkWell(
        onTap: () {
          bool isLogin = loginauth.getLoginStatus();
          isLogin ? Get.to(const NotificationsScreen()) : changeIndex(0);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Image.asset(
            'assets/images/notification.png',
            color: Colors.white,
          ),
        ),
      ),
      // ignore: unrelated_type_equality_checks
      (isLogin && notificationsController.notificationsCount != '0')
          ? Positioned(
              right: 18,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 219, 13, 15),
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Obx(() => Text(
                      notificationsController.notificationsCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
            )
          : Container()
    ]);
  }

  changeIndex(int index) {
    setState(() {
      widget.selectedIndex = index;
      bottomNavigationBarController.pageIndex.value = index;
    });
  }
}

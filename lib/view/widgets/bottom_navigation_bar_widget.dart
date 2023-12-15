import 'package:B2C/utility/themes_b2c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/bottom_navigationbar_controller.dart';

// ignore: must_be_immutable
class BottomBarWidget extends StatefulWidget {
  int selectedIndex;
  BottomBarWidget({super.key, required this.selectedIndex});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  final bottomBarController = Get.put(BottomNavigationBarController());

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Glamz',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              label: 'Appointments'.tr,
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle_rounded),
            label: 'Profile'.tr,
            backgroundColor: Colors.white,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.selectedIndex,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colr.primary,
        iconSize: 25,
        onTap: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
          bottomBarController.changeIndex(index);
        },
        elevation: 5);
  }
}

import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_elevated_button.dart';
import 'package:B2C/view/screens/Appointments/appointments_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppopintmentsScreen extends StatefulWidget {
  const MyAppopintmentsScreen({super.key});

  @override
  State<MyAppopintmentsScreen> createState() => _MyAppopintmentsScreenState();
}

class _MyAppopintmentsScreenState extends State<MyAppopintmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButtons(
        onPressed: () {
          Get.to(const AppointmentsList());
        },
        height: 50,
        width: 150,
        backgroundColor: Colr.primary,
        text: 'List of Appointments',
        textColor: Colr.primaryLight,
      ),
    );
  }
}

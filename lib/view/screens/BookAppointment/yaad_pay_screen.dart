import 'package:B2C/controller/book_appointment_controller.dart';
import 'package:B2C/controller/localization_controller.dart';

import 'package:B2C/utility/widget_helper/common_text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:B2C/utility/themes_b2c.dart';

import 'package:get/get.dart';

import '../../../controller/customer_controller.dart';

class YaadPayScreen extends StatefulWidget {
  const YaadPayScreen({super.key});

  @override
  State<YaadPayScreen> createState() => _YaadPayScreenState();
}

class _YaadPayScreenState extends State<YaadPayScreen> {
  // WebViewController? controller;
  String paymentUrl = "";
  bool isLoad = true;
  final bookAppointment = Get.put(BookAppointmentController());
  final customerController = Get.put(CustomerController());
  final localizationController = Get.put(LocalizationController());
  @override
  void initState() {
    super.initState();
    getPaymentUrl();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bookAppointment.isCardAdded.value = false;
        setState(() {});
        return whenBack();
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: localizationController.isHebrew.value
                ? null
                : IconButton(
                    onPressed: () {
                      whenBack();
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    )),
            actions: [
              localizationController.isHebrew.value
                  ? IconButton(
                      onPressed: () {
                        whenBack();
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                        size: 18,
                      ))
                  : Container()
            ],
            backgroundColor: Colr.primary,
            centerTitle: true,
            title: CommenTextWidget(
              s: "Credit details".tr,
              size: 22,
            ),
          ),
          body: isLoad
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                    // initialFile: "https://www.google.com",
                    initialUrlRequest: URLRequest(url: Uri.parse(paymentUrl)),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions()),
                    onWebViewCreated: (InAppWebViewController controller) {},
                  ))),
    );
  }

  whenBack() async {
    await bookAppointment
        .getCreditCardDetails(customerController.custInfo.value.id!);
  }

  Future<void> getPaymentUrl() async {
    paymentUrl = await bookAppointment.getPaymentUrl();

    setState(() {
      isLoad = false;
    });
  }
}

import 'package:B2C/main.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditDetails extends StatefulWidget {
  const CreditDetails({super.key});

  @override
  State<CreditDetails> createState() => _CreditDetailsState();
}

class _CreditDetailsState extends State<CreditDetails> {
  TextEditingController creditController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Text(
          'Credit Card'.tr,
          style: Colr.textStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Row(
                  children: [
                    Text(
                      "Enter Credit Card".tr,
                      style: Colr.textStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: Get.height * .085,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: TextFormField(
                            cursorColor: Colors.black,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: formKey,
                            controller: creditController,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey),
                                labelText: "Credit Number".tr,
                                border: InputBorder.none),
                            validator: (value) {
                              return null;
                            }),
                      ),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: Get.height * .075,
                      width: Get.width * .4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'CVV',
                                labelStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: Get.height * .075,
                      width: Get.width * .4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                labelText: 'Card Validity'.tr,
                                labelStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: Get.height * .075,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Cardholder's Name".tr,
                            labelStyle: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * .41,
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: Get.height * .07,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff580176),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Update".tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

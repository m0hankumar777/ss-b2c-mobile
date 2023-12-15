import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/view/screens/MenuScreens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utility/widget_helper/common_text_widget.dart';
import 'magazine_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final localizationController = Get.put(LocalizationController());

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
            s: "Menu".tr,
            fw: FontWeight.bold,
            size: 18,
            clr: Colors.black,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),

            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
              title: CommenTextWidget(
                s: 'Settings'.tr,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
              ),
              trailing: const Icon(
                (Icons.chevron_right),
                size: 30,
              ),
              onTap: () {
                Get.to(const SettingScreen());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // const Divider(),
            // ListTile(
            //   leading: const Icon(
            //     Icons.info_outline,
            //     color: Colors.black,
            //   ),
            //   title: CommenTextWidget(
            //     s: 'About'.tr,
            //     size: 18,
            //     fs: FontStyle.normal,
            //     fw: FontWeight.bold,
            //   ),
            //   trailing: const Icon(
            //     (Icons.chevron_right),
            //     size: 30,
            //   ),
            //   onTap: () {
            //     Get.to(const AboutScreen());
            //   },
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.book,
                color: Colors.black,
              ),
              title: CommenTextWidget(
                s: 'Magazine'.tr,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
              ),
              trailing: const Icon(
                (Icons.chevron_right),
                size: 30,
              ),
              onTap: () {
                Get.to(const MagazineScreen());
              },
            ),
            const SizedBox(
              height: 10,
            ),
            //const Divider(),
            // ListTile(
            //   leading: const Icon(
            //     Icons.article_outlined,
            //     color: Colors.black,
            //   ),
            //   title: CommenTextWidget(
            //     s: 'Blog'.tr,
            //     size: 18,
            //     fs: FontStyle.normal,
            //     fw: FontWeight.bold,
            //   ),
            //   trailing: const Icon(
            //     (Icons.chevron_right),
            //     size: 30,
            //   ),
            //   onTap: () {},
            // ),
          ],
        ));
  }

  Padding iconButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            localizationController.isHebrew.value
                ? Icons.arrow_forward_ios_outlined
                : Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 18,
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../utility/themes_b2c.dart';
import '../../../utility/widget_helper/common_text_widget.dart';

class MagazineScreen extends StatefulWidget {
  const MagazineScreen({super.key});

  @override
  State<MagazineScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MagazineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colr.primary,
        centerTitle: true,
        title: CommenTextWidget(
          s: "Magazine".tr,
          size: 22,
        ),
      ),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse("https://glamz-blog.webflow.io/")),
        initialOptions:
            InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions()),
        onWebViewCreated: (InAppWebViewController controller) {},
      ),
    );
  }
}

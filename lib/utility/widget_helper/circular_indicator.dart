import 'package:B2C/utility/themes_b2c.dart';
import 'package:flutter/material.dart';


  void  onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
            height: 50,
            child: Center(
                child: CircularProgressIndicator(
              color: Colr.primary,
            )));
      },
    );
  }
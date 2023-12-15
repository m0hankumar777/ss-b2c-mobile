import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: non_constant_identifier_names
List PopularServiceName = [
  "Women's Haircut",
  "Full Pedicure",
  "Hair Curling",
  "Face Treatments",
  "Eyebrow Shaping",
  "Evening Makeup",
  "Facial waxing",
  "Restorative hair Straightening",
];
// ignore: non_constant_identifier_names
List PopularServiceNameH = [
  "תספורת נשים",
  "פדיקור מלא",
  "סלסול שיער",
  "טיפולי פנים",
  "עיצוב גבות",
  "איפור ערב",
  "שעווה פאות",
  "החלקה משקמת"
];
List days = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];
List daysH = [
  "יוֹם רִאשׁוֹן",
  "יוֹם שֵׁנִי",
  "יוֹם שְׁלִישִׁי",
  "יום רביעי",
  "יוֹם חֲמִישִׁי",
  "יוֹם שִׁישִׁי",
  "יום שבת"
];
commonToast(String s) {
  return Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 188, 49, 39),
      textColor: Colors.white,
      fontSize: 16.0);
}

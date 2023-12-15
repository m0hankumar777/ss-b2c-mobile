import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CommenTextWidget extends StatelessWidget {
  final String s;
  FontWeight? fw;
  FontStyle? fs;
  double? size;
  Color? clr;
  TextStyle? ts;
  TextDecoration? decoration;
  TextAlign? align;
  TextOverflow? of;
  bool? sw;
  int? mxL;
  // ignore: use_key_in_widget_constructors
  CommenTextWidget({
    required this.s,
    this.fw,
    this.fs,
    this.clr,
    this.size,
    this.ts,
    this.decoration,
    this.align,
    this.of,
    this.sw,
    this.mxL,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      s,
      style: TextStyle(
        fontSize: size,
        fontWeight: fw,
        fontStyle: fs,
        color: clr,
        fontFamily: 'opensans',
        decoration: decoration,
      ),
      textAlign: align,
      overflow: of,
      softWrap: sw,
      maxLines: mxL,
    );
  }
}

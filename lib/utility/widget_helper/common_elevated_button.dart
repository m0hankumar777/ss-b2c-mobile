import 'package:flutter/material.dart';

class AppButtons extends StatelessWidget {
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? text;
  final IconData? icon;
  final double? size;
  final bool? isIcon;
  final bool isLoad;
  final Color loaderColor;
  final double loaderSize;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final double? width;
  final Decoration? decoration;
  final GestureTapCallback? onPressed;

  const AppButtons({
    super.key,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.text,
    this.size,
    this.icon,
    this.isIcon = false,
    this.isLoad = false,
    this.loaderColor = Colors.white,
    this.loaderSize = 25,
    this.onPressed,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.width,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        // ignore: sort_child_properties_last
        child: Center(
          child: isLoad
              ? SizedBox(
                  height: loaderSize,
                  width: loaderSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    color: loaderColor,
                  ),
                )
              : isIcon == false
                  ? Text(
                      text!,
                      style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: fontWeight),
                    )
                  : Icon(
                      icon,
                      color: textColor,
                    ),
        ),
        decoration: decoration ??
            BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: borderColor ?? Colors.white,
                  width: 1.0,
                )),
      ),
    );
  }
}

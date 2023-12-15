import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextFormFieldWidget extends StatelessWidget {
  TextEditingController controller;
  String? initialValue;
  InputDecoration? inputDecoration;
  final String? Function(String?) validatorFn;
  TextInputType? keyboardtype;
  Color? color;
  List<TextInputFormatter>? inputFormatters;
  void Function(String?)? onSaved;
  bool? autofocus = false;
  TextStyle? style;
 TextInputAction? textInputAction;

  // ignore: use_key_in_widget_constructors
  CustomTextFormFieldWidget({
    required this.controller,
    this.inputDecoration,
    this.initialValue,
    this.keyboardtype,
    this.color,
    required this.validatorFn,
    this.inputFormatters,
    this.onSaved,
    this.autofocus,
    this.style,
    this.textInputAction
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: inputDecoration,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validatorFn,
      keyboardType: keyboardtype,
      cursorColor: color,
      inputFormatters: inputFormatters,
      onSaved: onSaved,
      autofocus: autofocus ?? false,
      style: style,
      textInputAction: textInputAction,
    );
  }
}

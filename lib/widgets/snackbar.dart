import 'package:flutter/material.dart';
import '../data/colors.dart';

class RSnackBar {
  Color? textColor;
  Color? snackColor;
  Duration? duration;

  static const textStyle = TextStyle(
    fontFamily: 'Vazir',
    color: whiteTextColor,
  );

  RSnackBar(BuildContext context, SnackBar sn) {
    ScaffoldMessenger.of(context).showSnackBar(sn);
  }

  static success(BuildContext context, String text, {duration}) {
    SnackBar sn = SnackBar(
      content: Text(text, style: textStyle),
      backgroundColor: successColor,
      duration: duration is Duration ? duration : const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(sn);
  }

  static error(BuildContext context, String text, {duration}) {
    SnackBar sn = SnackBar(
      content: Text(text, style: textStyle),
      backgroundColor: errorColor,
      duration: duration is Duration ? duration : const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(sn);
  }

  static warning(BuildContext context, String text, {duration}) {
    SnackBar sn = SnackBar(
      content: Text(text, style: textStyle),
      backgroundColor: warningColor,
      duration: duration is Duration ? duration : const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(sn);
  }

  static info(BuildContext context, String text, {duration}) {
    SnackBar sn = SnackBar(
      content: Text(text, style: textStyle),
      backgroundColor: infoColor,
      duration: duration is Duration ? duration : const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(sn);
  }

  static hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

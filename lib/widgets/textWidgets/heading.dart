import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Heading extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  final String? fontFamily;

  Heading({
    super.key,
    required this.text,
    this.fontSize=18.0,
    this.fontWeight=FontWeight.w500,
    this.color,
    this.fontFamily,
    this.fontStyle
  });

  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontFamily:fontFamily
      ),
    ).paddingAll(5);
  }
}

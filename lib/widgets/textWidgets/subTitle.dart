import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  FontStyle? fontStyle;
  TextOverflow? overflow;

  SubTitle({
    super.key,
    required this.text,
    this.fontSize=12.0,
    this.fontWeight,
    this.color= Colors.grey,
    this.fontStyle,
    this.overflow
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
      fontSize: fontSize,
        fontWeight: fontWeight,
        color: color
    ),
      overflow: overflow,
    );
  }
}

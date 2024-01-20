import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  TextOverflow? overflow;

  TextTitle({
     super.key,
     required this.text,
     this.fontSize=12.0,
     this.fontWeight,
     this.color,
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
      overflow:overflow ,
    );
  }
}

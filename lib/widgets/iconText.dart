import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? fontSize;
  final double? iconSize;
  final Color ?color;
  final Function()? onTap;
  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.fontSize,
    this.iconSize,
    this.color,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10,),
          Text(text,style: TextStyle(
            color: color,fontSize: fontSize
          ),)
        ],
      ).paddingAll(10),
    );
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimension  {

  static double get screenHeight => Get.height;
  static double get screenWidth => Get.width;

   static double height(double value) {
    var factor = screenHeight / value;
    return screenHeight / factor;
  }
  static double width(double value) {
    var factor = screenWidth / value;
    return screenWidth / factor;
  }
  static double radius(double value) {
    var factor = screenWidth / value;
    return screenWidth / factor;
  }
  static double padding(double value) {
    var factor = screenHeight / value;
    return screenHeight / factor;
  }
  static double margin(double value) {
    var factor = screenHeight / value;
    return screenHeight / factor;
  }
  static double fontSize(double value) {
    var factor = screenHeight / value;
    return screenHeight / factor;
  }
  static double iconSize(double value) {
    var factor = screenHeight / value;
    return screenHeight / factor;
  }

}


//   static double pageView= screenHeight/2.59;
//   static double pageViewContainer= screenHeight/3.76;
//   static double pageViewTextContainer= screenWidth/6.9;
// //dynamic height padding and margin
//   static double height(double height){
//     var factor = screenHeight/height;
//     return screenHeight/factor;
//   }
//   static double height10 = screenHeight/82.9;
//   static double height15 = screenHeight/55.266;
//   static double height20 = screenHeight/40.1;
//   static double height30 = screenHeight/27.6333;
//   static double height45 = screenHeight/18.42;
// //dynamic width padding and margin
//   static double width10 = screenHeight/82.9;
//   static double width15 = screenHeight/55.266;
//   static double width30 = screenHeight/27.6333;
//   static double width20 = screenHeight/41.45;
// //fontSize
//   static double font16 =screenHeight/50.187;
//   static double font20 = screenHeight/41.45;
//   static double font26 = screenHeight/30.846;
//
//   //radius
//   static double radius15 = screenHeight/55.266;
//   static double radius20 = screenHeight/41.45;
//   static double radius30 = screenHeight/27.6333;
//   static double searchIcon = screenHeight/34.54;
//   //iconSize
//   static double iconSize24 =screenHeight/34.54;
//   static double iconSize16 =screenHeight/50.187;
//   //static double listViewImgSize =screenHein/
//   static double popularFoodImg =screenHeight/2.29;
//   static double bottomHeightBar =screenHeight/6.6833;
//
//
// }
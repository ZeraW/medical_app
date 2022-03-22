import 'package:flutter/material.dart';

class xColors {
  static const Color mainColor = Colors.indigo; //3F51B5
  static const Color pinkColor = Color(0xffF4DEFD);
  static const Color accentColor = Color(0xffD2FCFF);
  static const Color greenColor = Color(0xff84ae1a);
  static const Color btnColor = Color(0xff373951);
  static const Color offWhite = Color(0xffF1F1F1);
  static const Color textColor = Color(0xff373951);
  static const Color backGroundColor = Color(0xffd8dbff);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color hintColor = Colors.black45;

  static MaterialStateProperty<Color> materialColor(var color) {
    return MaterialStateProperty.all<Color>(color);
  }

  static MaterialStateProperty<OutlinedBorder> materialShape(var shape) {
    return MaterialStateProperty.all<OutlinedBorder>(shape);
  }
}

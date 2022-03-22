import 'package:flutter/material.dart';
import 'package:medical_app/utils/colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: xColors.mainColor,
    accentColor: xColors.accentColor,
    hintColor: Colors.white,
    dividerColor: Colors.grey,
    buttonColor: xColors.btnColor,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: xColors.mainColor,
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
        backgroundColor: xColors.materialColor(xColors.mainColor),)),
    textTheme: TextTheme(
      headline6: TextStyle( //search delegate font
        fontWeight: FontWeight.w400,
        color: xColors.mainColor,
      ),
      headline1: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.mainColor,
      ),
      headline2: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.mainColor,
      ),
      headline3: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.mainColor,
      ),
      headline4: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.mainColor,
      ),
      headline5: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.mainColor,
      ),
      bodyText1: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.textColor,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.textColor,
      ),
      button: TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.textColor,
      ),
      subtitle2: TextStyle(
        fontWeight: FontWeight.w400,
        color: xColors.textColor,
      ),
    ),
    appBarTheme: _appBarTheme(),
  );
}

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: xColors.white,),

    color: xColors.mainColor,
    iconTheme: IconThemeData(
      color: xColors.white,
    ),
    centerTitle: true,
  );
}

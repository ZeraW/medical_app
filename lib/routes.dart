import 'package:flutter/widgets.dart';
import 'package:medical_app/ui_screens/splash.dart';
import 'package:medical_app/wrapper.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => SplashScreen(),
  "Wrapper": (BuildContext context) => Wrapper(),
};
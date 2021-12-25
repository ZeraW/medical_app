import 'package:flutter/material.dart';
import 'package:medical_app/ui_screens/auth/choose_login_type/choose_login_type.dart';
import 'package:medical_app/ui_screens/auth/login.dart';
import 'package:medical_app/ui_screens/auth/register.dart';

class AuthManage extends ChangeNotifier {
  int pageState = 0;
  String type = '';

  void toggleWidgets({int currentPage, String type}) {
    this.pageState = currentPage;
    this.type = type;
    notifyListeners();
  }

  void onBackPressed() {
    if (pageState == 1) {
      this.pageState = 0;
      notifyListeners();
    } else if (pageState == 2) {
      this.pageState = 1;
      this.type = type;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Widget currentWidget() {
    if (pageState == 1) {
      return LoginScreen(type: type);
    } else if (pageState == 2) {
      return RegisterScreen(type: type);
    } else {
      return ChooseLoginType();
    }
  }



}

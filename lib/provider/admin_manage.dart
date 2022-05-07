import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/main_cities/components/add_edit_cities.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/main_cities/m_citys.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/sub_cities/components/add_edit_sub_cities.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/doctors/components/add_edit_doctors.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/doctors/m_doctors.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/locations/components/sos_info.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/locations/m_locations.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/specialities/components/add_edit_spec.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/specialities/m_spec.dart';
import 'package:medical_app/utils/enums.dart';
import 'package:provider/provider.dart';

class AdminManage extends ChangeNotifier {
  AdminPages page;
  String title = 'Reports';

  void changeAppBarTitle({String title}) {
    this.title = title;
    notifyListeners();
  }


  void toggleWidgets({AdminPages page}) {
    this.page = page;
    notifyListeners();
  }

  void onBackPressed() {
    /*if (pageState == 1) {
      this.pageState = 0;
      notifyListeners();
    } else if (pageState == 2) {
      this.pageState = 1;
      this.type = type;
      notifyListeners();
    } else {
      notifyListeners();
    }*/
  }

  Widget currentWidget() {
    if (page == AdminPages.city) {
      return ManageCitiesScreen();
    } else if (page == AdminPages.speciality) {
      return ManageSpecScreen();
    } else if (page == AdminPages.doctors) {
      return ManageDoctorsScreen();
    } else if (page == AdminPages.locations) {
      return  ManageLocationsScreen();
    } else {
      return SizedBox();
    }
  }
}

class CityManage extends ChangeNotifier {
  int addScreen = 0, editScreen = 0;
  CityModel city;

  void onBackPressed() {
    this.addScreen = 0;
    this.editScreen = 0;
    notifyListeners();
  }

  void showAddScreen() {
    this.addScreen = 1;
    this.editScreen = 0;

    notifyListeners();
  }

  void hideAddScreen() {
    this.addScreen = 0;
    this.editScreen = 0;

    notifyListeners();
  }

  void showEditScreen(CityModel city) {
    this.city = city;
    this.addScreen = 0;
    this.editScreen = 1;
    notifyListeners();
  }

  void hideEditScreen() {
    this.city = null;
    this.editScreen = 0;
    this.addScreen = 0;
    notifyListeners();
  }

  Widget currentWidget() {
    if (addScreen == 1) {
      return AddCitiesScreen();
    } else if (editScreen == 1) {
      return EditCitiesScreen();
    } else {
      return SizedBox();
    }
  }
}

class SubCityManage extends ChangeNotifier {
  int addScreen = 0, editScreen = 0;
  SubCityModel city;
  String currentCity;

  void onBackPressed() {
    this.addScreen = 0;
    this.editScreen = 0;
    notifyListeners();
  }

  void showAddScreen(String currentCity) {
    this.currentCity = currentCity;
    this.addScreen = 1;
    this.editScreen = 0;

    notifyListeners();
  }

  void hideAddScreen() {
    this.addScreen = 0;
    this.editScreen = 0;

    notifyListeners();
  }

  void showEditScreen(SubCityModel city) {
    this.city = city;
    this.addScreen = 0;
    this.editScreen = 1;
    notifyListeners();
  }

  void hideEditScreen() {
    this.city = null;
    this.editScreen = 0;
    this.addScreen = 0;
    notifyListeners();
  }

  Widget currentWidget() {
    if (addScreen == 1) {
      return AddSubCitiesScreen();
    } else if (editScreen == 1) {
      return EditSubCitiesScreen();
    } else {
      return SizedBox();
    }
  }
}


class SpecManage extends ChangeNotifier {
  int addScreen = 0, editScreen = 0;
  SpecialityModel model;

  void onBackPressed() {
    this.addScreen = 0;
    this.editScreen = 0;
    notifyListeners();
  }

  void showAddScreen() {
    this.addScreen = 1;
    this.editScreen = 0;

    notifyListeners();
  }

  void hideAddScreen() {
    this.addScreen = 0;
    this.editScreen = 0;

    notifyListeners();
  }

  void showEditScreen(SpecialityModel model) {
    this.model = model;
    this.addScreen = 0;
    this.editScreen = 1;
    notifyListeners();
  }

  void hideEditScreen() {
    this.model = null;
    this.editScreen = 0;
    this.addScreen = 0;
    notifyListeners();
  }

  Widget currentWidget() {
    if (addScreen == 1) {
      return AddScreen();
    } else if (editScreen == 1) {
      return EditScreen();
    } else {
      return SizedBox();
    }
  }
}

class DoctorManage extends ChangeNotifier {
  int addScreen = 0, editScreen = 0;
  DoctorModel model;
  String currentCity;
  void changeCurrentCity(String currentCity) {
    this.currentCity = currentCity;
    notifyListeners();
  }

  void onBackPressed() {
    this.addScreen = 0;
    this.editScreen = 0;
    notifyListeners();
  }

  void showAddScreen() {
    this.addScreen = 1;
    this.editScreen = 0;

    notifyListeners();
  }

  void hideAddScreen() {
    this.addScreen = 0;
    this.editScreen = 0;

    notifyListeners();
  }

  void showEditScreen(DoctorModel model) {
    this.model = model;
    this.addScreen = 0;
    this.editScreen = 1;
    notifyListeners();
  }

  void hideEditScreen() {
    this.model = null;
    this.editScreen = 0;
    this.addScreen = 0;
    notifyListeners();
  }

  Widget currentWidget() {
    if (addScreen == 1) {
      return StreamProvider(
          create: (_)=> DatabaseService().getLiveSubCities(currentCity),
          child: AddDScreen());
    } else if (editScreen == 1) {
      return EditDScreen();
    } else {
      return SizedBox();
    }
  }
}

class LocationsManage extends ChangeNotifier {
  int infoScreen = 0;
  HelpModel model;
  bool isNew = false;

  void onBackPressed() {
    this.infoScreen = 0;
    notifyListeners();
  }

  void isNewChanger(bool isNew) {
    this.isNew = isNew;
    this.infoScreen = 0;
    notifyListeners();
  }



  void showInfoScreen(HelpModel model) {
    this.model = model;
    this.infoScreen = 1;

    notifyListeners();
  }

  void hideInfoScreen() {
    this.infoScreen = 0;
    notifyListeners();
  }

  Widget currentWidget() {
    if (infoScreen == 1) {
      return SosInfo();
    } else {
      return SizedBox();
    }
  }
}

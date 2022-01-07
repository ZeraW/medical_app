import 'package:flutter/widgets.dart';
import 'package:medical_app/ui_screens/splash.dart';
import 'package:medical_app/wrapper.dart';

import 'ui_screens/home_widgets/admin/cities/main_cities/m_citys.dart';
import 'ui_screens/home_widgets/admin/cities/sub_cities/m_sub_citys.dart';
import 'ui_screens/home_widgets/admin/doctors/m_doctors.dart';
import 'ui_screens/home_widgets/admin/locations/m_locations.dart';
import 'ui_screens/home_widgets/admin/reports/m_reports.dart';
import 'ui_screens/home_widgets/admin/specialities/m_spec.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => SplashScreen(),
  "Wrapper": (BuildContext context) => Wrapper(),
  "ManageCitiesScreen": (BuildContext context) => ManageCitiesScreen(),
  "ManageSpecScreen": (BuildContext context) => ManageSpecScreen(),
  "ManageDoctorsScreen": (BuildContext context) => ManageDoctorsScreen(),
  "ManageLocationsScreen": (BuildContext context) => ManageLocationsScreen(),
  "ManageReportScreen": (BuildContext context) => ManageReportScreen(),
  "ManageSubCitiesScreen": (BuildContext context) => ManageSubCitiesScreen(),


};
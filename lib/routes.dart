import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/doctor_home.dart';
import 'package:medical_app/ui_screens/home_widgets/patient/patient_appointment.dart';
import 'package:medical_app/ui_screens/home_widgets/patient/patient_home.dart';
import 'package:medical_app/ui_screens/splash.dart';
import 'package:medical_app/wrapper.dart';
import 'package:provider/provider.dart';

import 'models/db_model.dart';
import 'ui_screens/home_widgets/admin/cities/main_cities/m_citys.dart';
import 'ui_screens/home_widgets/admin/cities/sub_cities/m_sub_citys.dart';
import 'ui_screens/home_widgets/admin/doctors/m_doctors.dart';
import 'ui_screens/home_widgets/admin/locations/m_locations.dart';
import 'ui_screens/home_widgets/manager/reports/all_doctor_report.dart';
import 'ui_screens/home_widgets/manager/reports/all_patient_report.dart';
import 'ui_screens/home_widgets/manager/reports/appointments_report.dart';
import 'ui_screens/home_widgets/manager/reports/profit_report.dart';
import 'ui_screens/home_widgets/manager/reports/m_reports.dart';
import 'ui_screens/home_widgets/admin/specialities/m_spec.dart';
import 'ui_screens/home_widgets/doctor/doctor_appointment.dart';
import 'ui_screens/home_widgets/doctor/m_appointments.dart';
import 'ui_screens/home_widgets/admin/profile_screen.dart';
import 'ui_screens/home_widgets/patient/search_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => SplashScreen(),
  "Wrapper": (BuildContext context) => Wrapper(),
  "ManageCitiesScreen": (BuildContext context) => ManageCitiesScreen(),
  "ManageSpecScreen": (BuildContext context) => ManageSpecScreen(),
  "ManageDoctorsScreen": (BuildContext context) => ManageDoctorsScreen(),
  "ManageLocationsScreen": (BuildContext context) => ManageLocationsScreen(),
  "ManageReportScreen": (BuildContext context) => ManageReportScreen(),
  "ManageSubCitiesScreen": (BuildContext context) => ManageSubCitiesScreen(),
  "finance_profit_Report": (BuildContext context) => ProfitReport(),
  "All_Doctors_Report": (BuildContext context) => AllDoctorsReport(),
  "All_Patients_Report": (BuildContext context) => AllPatientsReport(),
  "Appointments_Report": (BuildContext context) => AppointmentsReport(),
  "Profile": (BuildContext context) => StreamProvider<UserModel>.value(
      value: DatabaseService().getUserById, child: ProfileScreen()),
  "ManageAppointments": (BuildContext context) => ManageAppointments(),
  "doctorHome": (BuildContext context) => DoctorHome(),
  "DoctorAppointmentScreen": (BuildContext context) =>
      DoctorAppointmentScreen(),
  "patientHome": (BuildContext context) => PatientHome(),
  "QueryDoctor": (BuildContext context) => QueryDoctor(),
  "PatientAppointmentScreen": (BuildContext context) =>
      PatientAppointmentScreen(),
};

class Routes {
  static const String splashRoute = "/";
  static const String ManageCitiesScreen = "ManageCitiesScreen";
  static const String ManageSpecScreen = "ManageSpecScreen";
  static const String ManageDoctorsScreen = "ManageDoctorsScreen";
  static const String ManageLocationsScreen = "ManageLocationsScreen";
  static const String ManageReportScreen = "ManageReportScreen";
  static const String ManageSubCitiesScreen = "ManageSubCitiesScreen";

  static const String finance_profit_Report = "finance_profit_Report";
  static const String All_Doctors_Report = "All_Doctors_Report";
  static const String All_Patients_Report = "All_Patients_Report";

  static const String Appointments_Report = "Appointments_Report";
  static const String Profile = "Profile";
}


class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.ManageCitiesScreen:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ManageCitiesScreen());
      case Routes.ManageSpecScreen:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ManageSpecScreen());
      case Routes.ManageDoctorsScreen:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ManageDoctorsScreen());
      case Routes.ManageLocationsScreen:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ManageLocationsScreen());
      case Routes.ManageReportScreen:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ManageReportScreen());
      case Routes.ManageSubCitiesScreen:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ManageSubCitiesScreen());
      case Routes.finance_profit_Report:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => ProfitReport());
      case Routes.All_Doctors_Report:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => AllDoctorsReport());
      case Routes.All_Patients_Report:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => AllPatientsReport());
      case Routes.Appointments_Report:return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => AppointmentsReport());
      case Routes.Profile:
        return PageRouteBuilder(settings: settings,pageBuilder: (_, __, ___) => StreamProvider<UserModel>.value(
                value: DatabaseService().getUserById, child: ProfileScreen()));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('No Route Found'),
              ),
              body: const Center(child: Text('No Route Found')),
            ));
  }
}

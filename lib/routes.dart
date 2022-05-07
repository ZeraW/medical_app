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
import 'ui_screens/home_widgets/admin/reports/all_doctor_report.dart';
import 'ui_screens/home_widgets/admin/reports/all_patient_report.dart';
import 'ui_screens/home_widgets/admin/reports/appointments_report.dart';
import 'ui_screens/home_widgets/admin/reports/profit_report.dart';
import 'ui_screens/home_widgets/admin/reports/m_reports.dart';
import 'ui_screens/home_widgets/admin/specialities/m_spec.dart';
import 'ui_screens/home_widgets/doctor/doctor_appointment.dart';
import 'ui_screens/home_widgets/doctor/m_appointments.dart';
import 'ui_screens/home_widgets/admin/profile_screen.dart';
import 'ui_screens/home_widgets/patient/book_appointment_query.dart';

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
      value: DatabaseService().getUserById,
      child:  ProfileScreen()),
  "ManageAppointments": (BuildContext context) => ManageAppointments(),
  "doctorHome": (BuildContext context) => DoctorHome(),
  "DoctorAppointmentScreen": (BuildContext context) => DoctorAppointmentScreen(),
  "patientHome": (BuildContext context) => PatientHome(),
  "QueryDoctor": (BuildContext context) => QueryDoctor(),
  "PatientAppointmentScreen": (BuildContext context) => PatientAppointmentScreen(),




};



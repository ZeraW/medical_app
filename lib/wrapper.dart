import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/routes.dart';
import 'package:medical_app/ui_screens/auth/root.dart';
import 'package:medical_app/utils/themes.dart';
import 'package:provider/provider.dart';

import 'models/db_model.dart';
import 'provider/auth_manage.dart';
import 'services/database_api.dart';
import 'ui_screens/home_widgets/admin/home/home.dart';
import 'ui_screens/home_widgets/patient/sos_sender.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = context.watch<User>();

    // return either the Home or Authenticate widget
    if (user == null) {
      return ChangeNotifierProvider(
          create: (context) => AuthManage(), child: RootScreen());
    } else {
      var start = user.email.indexOf(".99") + 3;
      var end = user.email.indexOf("88");
      String type = user.email.substring(start,end);
      print('email ${user.email}');

      print('type $type');

      if(type == 'admin'){
        return StreamBuilder<UserModel>(
            stream: DatabaseService().getUserById,
            builder: (context, snapshot) {
              UserModel model = snapshot.data;
              return model !=null ? HomeScreen(model):SizedBox();
            }
        );
      }else if(type=='doctor'){
        print(user.uid);
        return  MultiProvider(providers: [
          StreamProvider<List<CityModel>>.value(
              value: DatabaseService().getLiveCities),
          StreamProvider<List<SubCityModel>>.value(
              value: DatabaseService().getLiveSubCity),
          StreamProvider<List<SpecialityModel>>.value(
              value: DatabaseService().getLiveSpeciality),
          StreamProvider<DoctorModel>.value(
              value: DatabaseService().getDoc(user.uid)),
          StreamProvider<List<PatientModel>>.value(
              value: DatabaseService().getLivePatients),
        ], child: MaterialApp(
            title: 'doctor',
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.docInstance.key,
            initialRoute: 'doctorHome',
            theme: appTheme(),
            routes: routes,
          ),
        );
      }else {
        print(user.uid);
        return  MultiProvider(providers: [
          StreamProvider<List<CityModel>>.value(
              value: DatabaseService().getLiveCities),
          StreamProvider<List<SubCityModel>>.value(
              value: DatabaseService().getLiveSubCity),
          StreamProvider<List<SpecialityModel>>.value(
              value: DatabaseService().getLiveSpeciality),
          StreamProvider<PatientModel>.value(
              value: DatabaseService().getPatient(user.uid)),
          StreamProvider<List<DiagnosisModel>>.value(
              value: DatabaseService().getLiveDiagnosis(user.uid)),
          StreamProvider<List<HistoryFilesModel>>.value(
              value: DatabaseService().getLiveHistoryFiles(user.uid)),
        ], child: Stack(
          children: [
            MaterialApp(
              title: 'patient',
              debugShowCheckedModeBanner: false,
              navigatorKey: NavigationService.patientInstance.key,
              initialRoute: 'patientHome',
              theme: appTheme(),
              routes: routes,
            ),
            SosSender()
          ],
        ),
        );
      }



    }
  }
}



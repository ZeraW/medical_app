import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/routes.dart';
import 'package:medical_app/ui_screens/auth/root.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/doctor_home.dart';
import 'package:medical_app/utils/themes.dart';
import 'provider/auth_manage.dart';
import 'services/database_api.dart';
import 'package:provider/provider.dart';
import 'ui_screens/home.dart';
import 'models/db_model.dart';

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
      var start = user.email.indexOf(".") + 1;
      var end = user.email.indexOf("@");
      String type = user.email.substring(start,end);

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
        return Container(child: Text('User'),);
      }

    }
  }
}



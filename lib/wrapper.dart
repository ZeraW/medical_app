import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/ui_screens/auth/root.dart';
import 'provider/auth_manage.dart';
import 'services/database_api.dart';
import 'ui_screens/auth/choose_login_type/choose_login_type.dart';
import 'package:provider/provider.dart';
import 'ui_screens/home.dart';
import 'models/db_model.dart';

class Wrapper extends StatefulWidget {
  static String UID = '';
  static String UNAME = '';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final user = /*Provider.of<User>(context)*/context.watch<User>();

    // return either the Home or Authenticate widget
    if (user == null) {
      return ChangeNotifierProvider(
          create: (context) => AuthManage(), child: RootScreen());
    } else {
      Wrapper.UID = user.uid;
      return StreamBuilder<UserModel>(
        stream: DatabaseService().getUserById,
        builder: (context, snapshot) {
          UserModel user = snapshot.data;
          return user !=null ? HomeScreen(user):SizedBox();
        }
      );
    }
  }
}



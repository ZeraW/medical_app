import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/ui_screens/auth/root.dart';
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

    final user = /*Provider.of<User>(context)*/context.watch<User>();

    // return either the Home or Authenticate widget
    if (user == null) {
      return ChangeNotifierProvider(
          create: (context) => AuthManage(), child: RootScreen());
    } else {
      return StreamBuilder<UserModel>(
        stream: DatabaseService().getUserById,
        builder: (context, snapshot) {
          UserModel userModel = snapshot.data;
          userModel!=null ?print(userModel.type):print('null');
          return userModel !=null ? HomeScreen(userModel):SizedBox();
        }
      );
    }
  }
}



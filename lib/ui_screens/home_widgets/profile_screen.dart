import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  UserModel user;

  ProfileScreen(this.user);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _userIdController = new TextEditingController();
  TextEditingController _nationalIdController = new TextEditingController();
  bool isEnabled = false;


  @override
  Widget build(BuildContext context) {



      _nameController.text = widget.user.name;
      _userIdController.text = widget.user.userId;
      _passwordController.text = widget.user.password;



    return widget.user != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.width(10,context),),
            child: ListView(
              children: [

                SizedBox(
                  height: Responsive.height(3.0,context),
                ),

                TextFormBuilder(
                  hint: "الاسم",
                  enabled: isEnabled,
                  controller: _nameController,
                ),
                SizedBox(
                  height: Responsive.height(3.0,context),
                ),
                TextFormBuilder(
                  hint: "كود المستخدم",
                  enabled: false,
                  controller: _userIdController,
                ),
                SizedBox(
                  height: Responsive.height(3.0,context),
                ),

                TextFormBuilder(
                  hint: "كلمة المرور",
                  keyType: TextInputType.text,
                  isPassword: false,
                  enabled: isEnabled,
                  controller: _passwordController,
                  errorText: '',
                ),
                SizedBox(
                  height: Responsive.height(3.0,context),
                ),

                Container(
                  margin: EdgeInsets.only(top: Responsive.height(2,context)),
                  height: Responsive.height(7.0,context),
                  width: Responsive.width(65,context),
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().signOut();
                    },
                    style: ButtonStyle(
                        backgroundColor: xColors.materialColor(Color(0xffc13001)),
                        shape: xColors.materialShape(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                    child: Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.width(4.0,context),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              ],
            ),
          )
        : Text('Loading User ...');
  }


}

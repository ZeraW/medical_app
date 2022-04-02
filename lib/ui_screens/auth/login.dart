import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/provider/auth_manage.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  String type;

  LoginScreen({this.type});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Responsive.isMobile(context)?Colors.white:xColors.mainColor,
        body: Responsive(
          tablet: Container(
            padding:  EdgeInsets.symmetric(horizontal: Responsive.width(32, context),vertical:Responsive.height(5, context) ),
            child: Container(color: Colors.white,child: Mobile(type: widget.type,)),
          ),
          desktop: Container(
            padding:  EdgeInsets.symmetric(horizontal: Responsive.width(32, context),vertical:Responsive.height(5, context) ),
            child: Container(color: Colors.white,child: Mobile(type: widget.type,)),
          ),
          mobile: Mobile(type: widget.type,),
        ),
      ),
    );
  }
}
class Mobile extends StatefulWidget {
  String type;

  Mobile({this.type});

  @override
  _MobileState createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _emailError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.width(4.0, context)),
      child: ListView(
        children: [
          SizedBox(
            height: Responsive.height(6, context),
          ),
          Center(
            child: Image.asset(
              "assets/images/logo_side.png",
            ),
          ),
          SizedBox(
            height: Responsive.height(12.0, context),
          ),
          TextFormBuilder(
            controller: _emailController,
            hint: "email",
            keyType: TextInputType.visiblePassword,
            errorText: _emailError,
          ),
          SizedBox(
            height: Responsive.height(3.0, context),
          ),
          PasswordFieldWidget(
            controller: _passwordController,
            hint: "password",
            errorText: _passwordError,
          ),
          SizedBox(
            height: Responsive.height(4.0, context),
          ),
          SizedBox(
            height: Responsive.height(7.0, context),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: xColors.materialColor(xColors.mainColor)),
              onPressed: () {
                 _login(context);
              },
              child: Text(
                "Login",
                style: TextStyle(
                    color: xColors.white,
                    fontSize: Responsive.isMobile(context)?  Responsive.width(4.0, context) : 25,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ), //Spacer(),
          SizedBox(
            height: Responsive.height(3.0, context),
          ),
          widget.type == 'doctor'
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    Provider.of<AuthManage>(context, listen: false)
                        .toggleWidgets(currentPage: 2, type: widget.type);
                  },
                  child: Center(
                    child: Text(
                      "signup new account",
                      style: TextStyle(
                          color: xColors.mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.isMobile(context)? Responsive.width(4.0, context):20),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      setState(() {
        _passwordError = '';
        _emailError = '';
      });
      await AuthService().signInWithEmailAndPassword(
          context: context,
          email: '${_emailController.text}.99${widget.type}88',
          password: _passwordController.text);

    } else {
      setState(() {
        if (email == null || email.isEmpty) {
          _emailError = "enter a valid email";
          _passwordError = '';
        } else {
          _passwordError = "enter a valid password";
          _emailError = '';
        }
      });
    }
  }
}

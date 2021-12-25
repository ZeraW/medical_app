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
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  String _phoneError = "";
  String _passwordError = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: Responsive.width(6.0, context)),
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
                controller: _phoneController,
                hint: "phone number",
                keyType: TextInputType.visiblePassword,
                errorText: _phoneError,
              ),
              SizedBox(
                height: Responsive.height(3.0, context),
              ),
              TextFormBuilder(
                controller: _passwordController,
                hint: "password",
                keyType: TextInputType.visiblePassword,
                isPassword: true,
                errorText: _passwordError,
              ),
              SizedBox(
                height: Responsive.height(4.0, context),
              ),
              SizedBox(
                height: Responsive.height(7.0, context),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          xColors.materialColor(xColors.mainColor)),
                  onPressed: () {
                    /* _login(context);*/
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: xColors.white,
                        fontSize: Responsive.width(4.0, context),
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
                              fontWeight: FontWeight.w800,
                              fontSize: Responsive.width(4.0, context)),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    String phone = _phoneController.text;
    String password = _passwordController.text;
    if (phone != null &&
        phone.isNotEmpty &&
        password != null &&
        password.isNotEmpty) {
      setState(() {
        _passwordError = '';
        _phoneError = '';
      });
      await AuthService().signInWithEmailAndPassword(
          context: context,
          email: '${_phoneController.text}.${widget.type}',
          password: _passwordController.text);
    } else {
      setState(() {
        if (phone == null || phone.isEmpty) {
          _phoneError = "enter a valid phone number";
          _passwordError = '';
        } else {
          _passwordError = "enter a valid password";
          _phoneError = '';
        }
      });
    }
  }
}

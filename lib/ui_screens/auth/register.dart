
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/provider/auth_manage.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  String type;

  RegisterScreen({this.type});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _repasswordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  String _nameError = "";
  String _phoneError = "";
  String _passError = "";
  String _rePassError = "";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          leading: GestureDetector(
            onTap: () => Provider.of<AuthManage>(context, listen: false)
                .toggleWidgets(currentPage: 1, type: widget.type),
            child: Icon(
              Icons.chevron_left,
              size: Responsive.width(7.0,context),
            ),
          ),
          title: Text(
            "Register",
          )),
      body: Container(
        height: Responsive.height(100,context),
        padding: EdgeInsets.symmetric(
            vertical: Responsive.height(2,context),
            horizontal: Responsive.width(4,context)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo_side.png",
                ),
              ),
              SizedBox(
                height: Responsive.height(3.5,context),
              ),
              TextFormBuilder(
                hint: "user name",
                controller: _nameController,
                errorText: _nameError,
              ),
              SizedBox(
                height: Responsive.height(3.0,context),
              ),

              TextFormBuilder(
                hint: "phone number",
                keyType: TextInputType.emailAddress,
                controller: _phoneController,
                errorText: _phoneError,
              ),
              SizedBox(
                height: Responsive.height(3.0,context),
              ),


              TextFormBuilder(
                hint: "password",
                isPassword: true,
                controller: _passwordController,
                errorText: _passError,
              ),
              SizedBox(
                height: Responsive.height(3.0,context),
              ),
              TextFormBuilder(
                hint: "confirm password",
                isPassword: true,
                controller: _repasswordController,
                errorText: _rePassError,
              ),
              SizedBox(
                height: Responsive.height(3.0,context),
              ),
              SizedBox(
                height: Responsive.height(7.0,context),
                child: RaisedButton(
                  onPressed: () {
                    /*_reg(context);*/
                  },
                  color: xColors.mainColor,
                  child: Text(
                    "Register a new user",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.width(4.0,context),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _reg(BuildContext context) async {
    String firstName = _nameController.text;
    String userId = _phoneController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String password = _passwordController.text;
    String passwordConfirm = _repasswordController.text;

    if (firstName == null || firstName.isEmpty) {
      _nameError = "Enter the username";
      setState(() {

      });
    } else if (userId == null || userId.isEmpty) {
      clear();
      _phoneError = "Enter a phone number";
    } else if (password == null || password.isEmpty) {
      clear();
      _passError = "Enter the password";
    } else if (passwordConfirm == null || passwordConfirm.isEmpty) {
      clear();
      _rePassError = "Enter Confirm Password";
    } else if (password != passwordConfirm) {
      clear();
      _passError = "Passwords do not match";
      _rePassError = "Passwords do not match";
    }else {
      clear();
      UserModel newUser = UserModel(
          name: firstName,
          password: password,
          userId: userId,
          type: widget.type);
      await AuthService().registerWithEmailAndPassword(
          context: context, newUser: newUser);
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _passError = "";
      _rePassError = "";
    });
  }
}

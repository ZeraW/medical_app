import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: user != null ? Body(user) : Text('null'),
    );
  }
}

class Body extends StatefulWidget {
  UserModel user;

  Body(this.user);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  String _nameError = "";
  String _phoneError = "";
  String _passError = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _passwordController.text = widget.user.password;
    _phoneController.text = widget.user.userId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(2, context),
              vertical: Responsive.height(1, context)),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      _editProfile();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Edit',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            xColors.materialColor(xColors.mainColor)),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    Wrap(
                      children: [
                        SizedBox(
                          height: Responsive.height(3.0, context),
                        ),
                        Container(
                          width: Responsive.width(37, context),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: TextFormBuilder(
                            hint: "user name",
                            controller: _nameController,
                            errorText: _nameError,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.height(3.0, context),
                        ),
                        Container(
                          width: Responsive.width(37, context),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: TextFormBuilder(
                            hint: "phone number",
                            keyType: TextInputType.emailAddress,
                            controller: _phoneController,
                            errorText: _phoneError,
                            enabled: false,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.height(3.0, context),
                        ),
                        Container(
                          width: Responsive.width(37, context),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: PasswordFieldWidget(
                            hint: "password",
                            controller: _passwordController,
                            errorText: _passError,
                          ),
                        ),
                        SizedBox(
                          height: Responsive.height(3.0, context),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _editProfile() async {
    String firstName = _nameController.text;
    String password = _passwordController.text;

    if (firstName == null || firstName.isEmpty) {
      _nameError = "Enter the username";
      setState(() {});
    } else if (password == null || password.isEmpty) {
      clear();
      _passError = "Enter the password";
    } else if (password == widget.user.password &&
        firstName == widget.user.name) {
      clear();
    } else {
      clear();
      UserModel newUser = UserModel(
          name: firstName,
          password: password,
          userId: widget.user.userId,
          id: widget.user.id,
          type: widget.user.type);

      AuthService().changePassword(
          password != widget.user.password ? password : null, () async {
        await DatabaseService().updateUserData(user: newUser);
      });

     // NavigationService2.instance.goBack();
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _passError = "";
    });
  }
}

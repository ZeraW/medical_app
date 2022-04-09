import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/drop_down.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.dart';

class PatientProfile extends StatefulWidget {
  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  @override
  Widget build(BuildContext context) {
    PatientModel user = Provider.of<PatientModel>(context);
    List<SpecialityModel> specialityModel =
        Provider.of<List<SpecialityModel>>(context);
    List<CityModel> cityModel = Provider.of<List<CityModel>>(context);
    List<SubCityModel> subCityModel = Provider.of<List<SubCityModel>>(context);

    print(user);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: user != null &&
              specialityModel != null &&
              cityModel != null &&
              subCityModel != null
          ? Body(user, specialityModel, cityModel, subCityModel)
          : Text('null'),
    );
  }
}

class Body extends StatefulWidget {
  PatientModel user;
  List<SpecialityModel> specialityModel;

  List<CityModel> cityModel;

  List<SubCityModel> subCityModel;

  Body(this.user, this.specialityModel, this.cityModel, this.subCityModel);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isEnabled = false;
  File pickedImage;

  String imageUrl;
  String gender;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _ageController = new TextEditingController();


  String _nameError = "";
  String _ageError = "";

  String _phoneError = "";
  String _passError = "";
  String _genderError = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;

    _passwordController.text = widget.user.password;
    _ageController.text = widget.user.age;

    _phoneController.text = widget.user.phone;
    imageUrl = widget.user.image;
    gender = widget.user.gender.toString();
  }

  Future<void> _takePicture() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    } else {
      pickedImage = File(imageFile.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Profile',
            style: TextStyle(
                color: xColors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.width(5, context)),
          ),
          actions: [
            Builder(builder: (ctx) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.width(5, context)),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isEnabled ? isEnabled = false : isEnabled = true;
                    });

                    if (!isEnabled) {
                      _apiRequest();
                    }
                    /*
                    isEnabled
                        ? Provider.of<ProfileManage>(context, listen: false)
                        .restEdit()
                        : '';*/
                  },
                  child: Row(
                    children: [
                      Icon(
                        isEnabled ? Icons.check : Icons.edit,
                      ),
                      SizedBox(
                        width: Responsive.width(2, context),
                      ),
                      Text(
                        isEnabled ? 'save' : 'edit',
                        style: TextStyle(fontSize: 16, color: xColors.white),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: Responsive.height(100.0, context),
              width: Responsive.width(100, context),
              color: Colors.transparent,
            ),
            Positioned(
              child: Container(
                height: Responsive.height(10.0, context),
                width: Responsive.width(100, context),
                color: xColors.mainColor,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                alignment: Alignment.center,
                width: Responsive.height(20, context),
                height: Responsive.height(20, context),
                margin: EdgeInsets.all(4),
                child: GestureDetector(
                  onTap: isEnabled ? _takePicture : null,
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: pickedImage != null
                          ? Image.file(pickedImage)
                          : CachedNetworkImage(
                              imageUrl: "${widget.user.image}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 90,
                                color: xColors.accentColor,
                              ),
                            ),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                          color: isEnabled
                              ? Theme.of(context).accentColor
                              : Colors.transparent,
                          width: 3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Responsive.height(21.0, context),
              left: 0.0,
              right: 0.0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
                    TextFormBuilder(
                      hint: "Patient Name",
                      keyType: TextInputType.text,
                      controller: _nameController,
                      errorText: _nameError,
                      activeBorderColor: xColors.mainColor,
                      enabled: isEnabled,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),TextFormBuilder(
                      hint: "Email",
                      keyType: TextInputType.phone,
                      controller: _emailController,
                      enabled: false,
                      errorText: '',
                      activeBorderColor: xColors.mainColor,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    TextFormBuilder(
                      hint: "Phone Number",
                      keyType: TextInputType.phone,
                      controller: _phoneController,
                      enabled: isEnabled,
                      errorText: _phoneError,
                      activeBorderColor: xColors.mainColor,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    TextFormBuilder(
                      hint: "age",
                      keyType: TextInputType.number,
                      controller: _ageController,
                      errorText: _ageError,
                      enabled: isEnabled,
                      activeBorderColor: xColors.mainColor,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    PasswordFieldWidget(
                      controller: _passwordController,
                      hint: "password",
                      errorText: _passError,
                      enabled: isEnabled,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    DropDownStringList(
                      hint: 'Gender',
                      mList: ['Male', 'Female'],
                      selectedItem: gender,
                      errorText: _genderError,
                      enabled: isEnabled,
                      onChange: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),


                    ElevatedButton(
                        onPressed: () async{
                          await AuthService().signOut();
                        },style: ButtonStyle(backgroundColor:  xColors.materialColor(Colors.red)),
                        child: Text('logout',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Responsive.width(4.5, context)))),
                    SizedBox(
                      height: Responsive.height(2, context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _apiRequest() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String age = _ageController.text;


    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Patient Name";
      });
    } else if (phone == null || phone.isEmpty|| phone.length!=11 ) {
      clear();
      setState(() {
        _phoneError = "Please enter valid Phone Number";
      });
    } else if (age == null || age.isEmpty) {
      clear();
      setState(() {
        _phoneError = "Please enter age";
      });
    } else if (password == null || password.isEmpty || password.length < 5) {
      clear();
      setState(() {
        _passError = "Please enter Password 6 letters or more";
      });
    } else if (gender == null || gender.isEmpty) {
      clear();
      setState(() {
        _genderError = "Please Select Gender";
      });
    } else {
      clear();
      //do request
      PatientModel newModel = PatientModel(
          id: widget.user.id,
          name: name,
          image: pickedImage == null ? widget.user.image : null,
          phone: phone,
          age: age,
          gender: gender,
          password: password,);
      await DatabaseService().updatePatient(
          updated: newModel,
          image: pickedImage,
          passChanged: widget.user.password != password);
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _passError = '';
      _phoneError = "";
      _genderError = "";
      _ageError ="";

    });
  }
}

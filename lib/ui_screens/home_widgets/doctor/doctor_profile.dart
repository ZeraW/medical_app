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

class DoctorProfile extends StatefulWidget {
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    DoctorModel user = Provider.of<DoctorModel>(context);
    List<SpecialityModel> specialityModel =
        Provider.of<List<SpecialityModel>>(context);
    List<CityModel> cityModel = Provider.of<List<CityModel>>(context);
    List<SubCityModel> subCityModel = Provider.of<List<SubCityModel>>(context);

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
  DoctorModel user;
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

  SpecialityModel selectedSpeciality;
  CityModel selectedCity;
  SubCityModel selectedSubCity;
  Map<String, String> keyWords;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _aboutController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _consultationFeesController =
      new TextEditingController();

  String _nameError = "";
  String _aboutError = "";
  String _addressError = "";
  String _phoneError = "";
  String _passError = "";
  String _subCityError = "";
  String _genderError = "";
  String _cityError = "";
  String _specialtyError = "";
  String _consultationFeesError = "";

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _emailController.text = widget.user.email;

    _aboutController.text = widget.user.about;
    _passwordController.text = widget.user.password;
    _phoneController.text = widget.user.phone;
    _addressController.text = widget.user.address;
    _consultationFeesController.text = widget.user.fees;
    keyWords = widget.user.keyWords;

    selectedSpeciality = widget.specialityModel.firstWhere(
        (element) => element.id == widget.user.specialty,
        orElse: () => SpecialityModel(id: 'null', name: 'Removed'));
    selectedCity = widget.cityModel.firstWhere(
        (element) => element.id == widget.user.city,
        orElse: () => CityModel(id: 'null', name: 'Removed'));
    selectedSubCity = widget.subCityModel.firstWhere(
        (element) => element.id == widget.user.subCity,
        orElse: () => SubCityModel(id: 'null', name: 'Removed'));
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
                      hint: "Doctor Name",
                      keyType: TextInputType.text,
                      controller: _nameController,
                      errorText: _nameError,
                      activeBorderColor: xColors.mainColor,
                      enabled: false,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    TextFormBuilder(
                      hint: "Email",
                      keyType: TextInputType.emailAddress,
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
                      hint: "Address",
                      keyType: TextInputType.streetAddress,
                      controller: _addressController,
                      errorText: _addressError,
                      enabled: false,
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
                    TextFormBuilder(
                      hint: "Consultation Fees",
                      keyType: TextInputType.number,
                      controller: _consultationFeesController,
                      enabled: isEnabled,
                      errorText: _consultationFeesError,
                      activeBorderColor: xColors.mainColor,
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    DropDownDynamicList(
                        mList: widget.specialityModel,
                        errorText: _specialtyError,
                        selectedItem: selectedSpeciality,
                        enabled: false,
                        hint: "Specialty",
                        onChange: (dynamic value) {
                          setState(() {
                            selectedSpeciality = value;
                          });
                        }),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    DropDownDynamicList(
                        mList: widget.cityModel,
                        errorText: _cityError,
                        selectedItem: selectedCity,
                        enabled: false,
                        hint: "City",
                        onChange: (dynamic value) {
                          setState(() {
                            selectedCity = value;
                            selectedSubCity = null;
                          });
                        }),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    selectedCity != null
                        ? StreamBuilder<List<SubCityModel>>(
                            stream: DatabaseService()
                                .getLiveSubCities(selectedCity.id),
                            builder: (context, snapshot) {
                              List<SubCityModel> mSubCityList = snapshot.data;

                              if (mSubCityList != null) {
                                SubCityModel oldSubCity =
                                    mSubCityList.firstWhere(
                                        (element) =>
                                            element.id == widget.user.subCity,
                                        orElse: () => SubCityModel(
                                            id: 'null', name: 'Removed'));
                                if (selectedSubCity == null &&
                                    oldSubCity.mainCityId == selectedCity.id) {
                                  selectedSubCity = oldSubCity;
                                }
                              }
                              return mSubCityList != null
                                  ? DropDownDynamicList(
                                      mList: mSubCityList,
                                      errorText: _subCityError,
                                      selectedItem: selectedSubCity,
                                      enabled: false,
                                      hint: "Area",
                                      onChange: (dynamic value) {
                                        setState(() {
                                          selectedSubCity = value;
                                        });
                                      })
                                  : SizedBox();
                            })
                        : SizedBox(),
                    SizedBox(
                      height: Responsive.height(
                          selectedCity != null ? 3 : 0, context),
                    ),
                    DropDownStringList(
                      hint: 'Gender',
                      mList: ['Male', 'Female'],
                      selectedItem: gender,
                      errorText: _genderError,
                      enabled: false,
                      onChange: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: Responsive.height(3, context),
                    ),
                    TextFormBuilder(
                      hint: "About Doctor",
                      keyType: TextInputType.text,
                      controller: _aboutController,
                      enabled: isEnabled,
                      errorText: _aboutError,
                      activeBorderColor: xColors.mainColor,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: Responsive.height(2, context),
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
  void createSearchKeywordsList(){
    keyWords['name']=_nameController.text.toLowerCase().toString();
    keyWords['spec']=selectedSpeciality.id.toString();
    keyWords['city']=selectedCity.id.toString();
    keyWords['subCity']=selectedSubCity.id.toString();
    keyWords['gender']=gender.toString();
    keyWords['fees']=_consultationFeesController.text.toString();

  }
  void _apiRequest() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String about = _aboutController.text;
    String password = _passwordController.text;
    String fees = _consultationFeesController.text;

    String spec = selectedSpeciality.id;
    String city = selectedCity.id;
    String subCity = selectedSubCity.id;

    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Doctor Name";
      });
    } else if (phone == null || phone.isEmpty ||phone.length!=11 ) {
      clear();
      setState(() {
        _phoneError = "Please enter valid Phone Number";
      });
    } else if (address == null || address.isEmpty) {
      clear();
      setState(() {
        _phoneError = "Please enter street address";
      });
    } else if (password == null || password.isEmpty || password.length < 5) {
      clear();
      setState(() {
        _passError = "Please enter Password 6 letters or more";
      });
    }else if (fees == null || fees.isEmpty) {
      clear();
      setState(() {
        _consultationFeesError = "Please enter Consultation Fees";
      });
    } else if (spec == null || spec.isEmpty) {
      clear();
      setState(() {
        _specialtyError = "Please Select Specialty";
      });
    } else if (city == null || city.isEmpty) {
      clear();
      setState(() {
        _cityError = "Please Select City";
      });
    } else if (subCity == null || subCity.isEmpty) {
      clear();
      setState(() {
        _subCityError = "Please Select Area";
      });
    } else if (gender == null || gender.isEmpty) {
      clear();
      setState(() {
        _genderError = "Please Select Gender";
      });
    } else {
      clear();
      //do request
      createSearchKeywordsList();
      DoctorModel newModel = DoctorModel(
          id: widget.user.id,
          name: name,
          specialty: spec,
          image: pickedImage == null ? widget.user.image : null,
          phone: phone,
          gender: gender,
          about: about,
          email: widget.user.email,
          appointments: widget.user.appointments,
          keyWords: keyWords,
          rate: widget.user.rate,
          address: address,fees: fees,
          password: password,
          subCity: subCity,
          city: city);
      await DatabaseService().updateDoctor(
          updatedDoctor: newModel,
          image: pickedImage,
          passChanged: widget.user.password != password);
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _passError = '';
      _aboutError = '';
      _phoneError = "";
      _genderError = "";
      _cityError = "";
      _specialtyError = "";
      _addressError = "";
      _consultationFeesError = "";
    });
  }
}

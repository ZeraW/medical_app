import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/drop_down.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';

class AddDScreen extends StatefulWidget {
  @override
  _AddDScreenState createState() => _AddDScreenState();
}

class _AddDScreenState extends State<AddDScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  SpecialityModel selectedSpeciality;
  SubCityModel selectedSubCity;
  Map<String,String> keyWords={};

  CityModel selectedCity;
  String gender;

  String _nameError = "";
  String _addressError = "";
  String _phoneError = "";
  String _emailError = "";

  String _subCityError = "";
  String _genderError = "";
  String _cityError = "";
  String _specialtyError = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Responsive.height(1, context),
                  ),
                  SelectableText(
                    'Add Doctor',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: Dim.addScreenTitle,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Responsive.height(2, context),
                  ),
                  TextFormBuilder(
                    hint: "Doctor Name",
                    keyType: TextInputType.text,
                    controller: _nameController,
                    errorText: _nameError,
                    activeBorderColor: xColors.mainColor,
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  TextFormBuilder(
                    hint: "Email",
                    keyType: TextInputType.emailAddress,
                    controller: _emailController,
                    errorText: _emailError,
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  TextFormBuilder(
                    hint: "Phone Number",
                    keyType: TextInputType.phone,
                    controller: _phoneController,
                    errorText: _phoneError,
                    activeBorderColor: xColors.mainColor,
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  TextFormBuilder(
                    hint: "Address",
                    keyType: TextInputType.text,
                    controller: _addressController,
                    errorText: _addressError,
                    activeBorderColor: xColors.mainColor,
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  mSpecList != null
                      ? DropDownDynamicList(
                          mList: mSpecList,
                          errorText: _specialtyError,
                          selectedItem: selectedSpeciality,
                          hint: "Specialty",
                          onChange: (dynamic value) {
                            setState(() {
                              selectedSpeciality = value;
                            });
                          })
                      : SizedBox(),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  mCityList != null
                      ? DropDownDynamicList(
                          mList: mCityList,
                          errorText: _cityError,
                          selectedItem: selectedCity,
                          hint: "City",
                          onChange: (dynamic value) {
                            context
                                .read<DoctorManage>()
                                .changeCurrentCity(value.id);

                            setState(() {
                              selectedCity = value;
                              selectedSubCity = null;
                            });
                          })
                      : SizedBox(),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  selectedCity != null
                      ? StreamBuilder<List<SubCityModel>>(
                          stream: DatabaseService()
                              .getLiveSubCities(selectedCity.id),
                          builder: (context, snapshot) {
                            List<SubCityModel> mSubCityList = snapshot.data;

                            return mSubCityList != null
                                ? DropDownDynamicList(
                                    mList: mSubCityList,
                                    errorText: _subCityError,
                                    selectedItem: selectedSubCity,
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
                    onChange: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: () {
                        _apiRequest();
                      },
                      color: xColors.mainColor,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Add Doctor',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _apiRequest() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String email = _emailController.text;

    String spec = selectedSpeciality.id;
    String city = selectedCity.id;
    String subCity = selectedSubCity.id;

    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Doctor Name";
      });
    }  else if (email == null || email.isEmpty || !isEmail(email)) {
      clear();
      _emailError = "Enter a valid Email";
    }else if (phone == null || phone.isEmpty|| phone.length!=11 || phone.length>11) {
      clear();
      setState(() {
        _phoneError = "Please enter valid Phone Number";
      });
    } else if (address == null || address.isEmpty) {
      clear();
      setState(() {
        _phoneError = "Please enter street address";
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
          name: name,
          specialty: spec,
          phone: phone,
          gender: gender,email: email,
          subCity: subCity,
          address: address,
          patients: {},
          password: '123456',
          keyWords: keyWords,
          city: city);

      await AuthService()
          .registerDocWithoutLogin(context: context, newDoctor: newModel);
      context.read<DoctorManage>().hideAddScreen();
    }
  }
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
  void createSearchKeywordsList(){
    keyWords['name']=_nameController.text.toLowerCase().toString();
    keyWords['spec']=selectedSpeciality.id.toString();
    keyWords['city']=selectedCity.id.toString();
    keyWords['subCity']=selectedSubCity.id.toString();
    keyWords['gender']=gender.toString();
  }

  void clear() {
    setState(() {
      _nameError = "";
      _phoneError = "";
      _genderError = "";
      _emailError = "";

      _cityError = "";
      _specialtyError = "";
      _addressError = "";
    });
  }
}

class EditDScreen extends StatefulWidget {
  EditDScreen();

  @override
  _EditDScreenState createState() => _EditDScreenState();
}

class _EditDScreenState extends State<EditDScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  Map<String,String> keyWords;

  SpecialityModel selectedSpeciality;
  CityModel selectedCity;
  SubCityModel selectedSubCity;

  String gender;
  String id;

  String _nameError = "";
  String _addressError = "";
  String _phoneError = "";
  String _genderError = "";
  String _cityError = "";
  String _subCityError = "";
  String _specialtyError = "";

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);
    if (_nameController.text == null || _nameController.text.isEmpty)
      _nameController.text =
          context.watch<DoctorManage>().model.name.toString();
    if (_addressController.text == null || _addressController.text.isEmpty)
      _addressController.text =
          context.watch<DoctorManage>().model.address.toString();
    if (_emailController.text == null || _emailController.text.isEmpty)
      _emailController.text =
          context.watch<DoctorManage>().model.email.toString();

    id = context.watch<DoctorManage>().model.id.toString();
    if (_phoneController.text == null || _phoneController.text.isEmpty)
      _phoneController.text =
          context.watch<DoctorManage>().model.phone.toString();
    if (mSpecList != null && selectedSpeciality == null)
      selectedSpeciality = mSpecList.firstWhere(
          (element) =>
              element.id == context.watch<DoctorManage>().model.specialty,
          orElse: () => SpecialityModel(id: 'null', name: 'Removed'));
    if (mCityList != null && selectedCity == null)
      selectedCity = mCityList.firstWhere(
          (element) => element.id == context.watch<DoctorManage>().model.city,
          orElse: () => CityModel(id: 'null', name: 'Removed'));
    if (gender == null)
      gender = context.watch<DoctorManage>().model.gender.toString();
    if (keyWords == null)
      keyWords = context.watch<DoctorManage>().model.keyWords;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Responsive.height(1, context),
                  ),
                  SelectableText(
                    'Edit Doctor',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: Dim.addScreenTitle,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Responsive.height(2, context),
                  ),
                  TextFormBuilder(
                    hint: "Doctor Name",
                    keyType: TextInputType.text,
                    controller: _nameController,
                    errorText: _nameError,
                    activeBorderColor: xColors.mainColor,
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  TextFormBuilder(
                    hint: "Email",
                    keyType: TextInputType.emailAddress,
                    enabled: false,
                    controller: _emailController,
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
                    activeBorderColor: xColors.mainColor,
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  mSpecList != null
                      ? DropDownDynamicList(
                          mList: mSpecList,
                          errorText: _specialtyError,
                          selectedItem: selectedSpeciality,
                          hint: "Specialty",
                          onChange: (dynamic value) {
                            setState(() {
                              selectedSpeciality = value;
                            });
                          })
                      : SizedBox(),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  mCityList != null
                      ? DropDownDynamicList(
                          mList: mCityList,
                          errorText: _cityError,
                          selectedItem: selectedCity,
                          hint: "City",
                          onChange: (dynamic value) {
                            setState(() {
                              selectedCity = value;
                              selectedSubCity = null;
                            });
                          })
                      : SizedBox(),
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
                              SubCityModel oldSubCity = mSubCityList.firstWhere(
                                  (element) =>
                                      element.id ==
                                      context
                                          .read<DoctorManage>()
                                          .model
                                          .subCity,
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
                    onChange: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: Responsive.height(3, context),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      onPressed: () {
                        _apiRequest();
                      },
                      color: xColors.mainColor,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Edit Doctor',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _apiRequest() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;

    String spec = selectedSpeciality.id;
    String city = selectedCity.id;
    String subCity = selectedSubCity.id;

    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Doctor Name";
      });
    } else if (phone == null || phone.isEmpty||phone.length!=11 || phone.length>11) {
      clear();
      setState(() {
        _phoneError = "Please enter valid Phone Number";
      });
    } else if (address == null || address.isEmpty) {
      clear();
      setState(() {
        _phoneError = "Please enter street address";
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
          id: id,
          name: name,
          specialty: spec,
          phone: phone,
          email: _emailController.text,
          gender: gender,
          address: address,
          fees: context.read<DoctorManage>().model.fees,
          image: context.read<DoctorManage>().model.image,
          rate: context.read<DoctorManage>().model.rate,
          appointments: context.read<DoctorManage>().model.appointments,
          about: context.read<DoctorManage>().model.about,
          patients: context.read<DoctorManage>().model.patients,

          keyWords: keyWords,
          password: context.read<DoctorManage>().model.password,
          subCity: subCity,
          city: city);

      print('resdsd');
      await DatabaseService().updateDoctor(updatedDoctor: newModel,passChanged: false);
      context.read<DoctorManage>().hideEditScreen();
    }
  }

  void createSearchKeywordsList(){
    keyWords['name']=_nameController.text.toLowerCase().toString();
    keyWords['spec']=selectedSpeciality.id.toString();
    keyWords['city']=selectedCity.id.toString();
    keyWords['subCity']=selectedSubCity.id.toString();
    keyWords['gender']=gender.toString();
  }

  void clear() {
    setState(() {
      _nameError = "";
      _phoneError = "";
      _genderError = "";
      _cityError = "";
      _specialtyError = "";
      _addressError = "";
    });
  }
}

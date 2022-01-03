import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/drop_down.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class AddDScreen extends StatefulWidget {
  @override
  _AddDScreenState createState() => _AddDScreenState();
}

class _AddDScreenState extends State<AddDScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  SpecialityModel selectedSpeciality;
  CityModel selectedCity;
  String gender;

  String _nameError = "";
  String _phoneError = "";
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
                  Text(
                    'Add Doctor',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 20,
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
                    hint: "Phone Number",
                    keyType: TextInputType.phone,
                    controller: _phoneController,
                    errorText: _phoneError,
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
                            });
                          })
                      : SizedBox(),
                  SizedBox(
                    height: Responsive.height(3, context),
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
    String spec = selectedSpeciality.id;
    String city = selectedCity.id;

    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Doctor Name";
      });
    } else if (phone == null || phone.isEmpty) {
      clear();
      setState(() {
        _phoneError = "Please enter Phone Number";
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
    } else if (gender == null || gender.isEmpty) {
      clear();
      setState(() {
        _genderError = "Please Select Gender";
      });
    } else {
      clear();
      //do request
      DoctorModel newModel = DoctorModel(
          name: name,
          specialty: spec,
          phone: phone,
          gender: gender,
          city: city);

      await AuthService().registerDocWithoutLogin(context: context,newDoctor: newModel);
      context.read<DoctorManage>().hideAddScreen();
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _phoneError = "";
      _genderError = "";
      _cityError = "";
      _specialtyError = "";
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
  SpecialityModel selectedSpeciality;
  CityModel selectedCity;
  String gender;
  String id;

  String _nameError = "";
  String _phoneError = "";
  String _genderError = "";
  String _cityError = "";
  String _specialtyError = "";

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);

    if (_nameController.text == null || _nameController.text.isEmpty)
      _nameController.text =
          context.watch<DoctorManage>().model.name.toString();
    id = context.watch<DoctorManage>().model.id.toString();
    if (_phoneController.text == null || _phoneController.text.isEmpty)
      _phoneController.text =
          context.watch<DoctorManage>().model.phone.toString();
    if (selectedSpeciality == null)
      selectedSpeciality = mSpecList.firstWhere((element) =>
          element.id == context.watch<DoctorManage>().model.specialty);
    if (selectedCity == null)
      selectedCity = mCityList.firstWhere(
          (element) => element.id == context.watch<DoctorManage>().model.city);
    if (gender == null || gender.isEmpty)
      gender = context.watch<DoctorManage>().model.gender.toString();

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
                  Text(
                    'Edit Doctor',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 20,
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
                    hint: "Phone Number",
                    keyType: TextInputType.phone,
                    controller: _phoneController,
                    enabled: false,
                    errorText: _phoneError,
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
                            });
                          })
                      : SizedBox(),
                  SizedBox(
                    height: Responsive.height(3, context),
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
    String spec = selectedSpeciality.id;
    String city = selectedCity.id;

    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Doctor Name";
      });
    } else if (phone == null || phone.isEmpty) {
      clear();
      setState(() {
        _phoneError = "Please enter Phone Number";
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
    } else if (gender == null || gender.isEmpty) {
      clear();
      setState(() {
        _genderError = "Please Select Gender";
      });
    } else {
      clear();
      //do request
      DoctorModel newModel = DoctorModel(
          id: id,
          name: name,
          specialty: spec,
          phone: phone,
          gender: gender,
          city: city);
      await DatabaseService().updateDoctor(updatedDoctor: newModel);
      context.read<DoctorManage>().hideEditScreen();
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
      _phoneError = "";
      _genderError = "";
      _cityError = "";
      _specialtyError = "";
    });
  }
}

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

class AddDiagnosisScreen extends StatefulWidget {
  @override
  _AddDiagnosisScreenState createState() => _AddDiagnosisScreenState();
}

class _AddDiagnosisScreenState extends State<AddDiagnosisScreen> {
 /* TextEditingController _patientNameController = new TextEditingController();
  TextEditingController _doctorNameController = new TextEditingController();
  TextEditingController _specController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();*/
  TextEditingController _complainController = new TextEditingController();
  TextEditingController _diagnosisController = new TextEditingController();
  TextEditingController _treatmentController = new TextEditingController();

/*  String selectedSpeciality;

  String _patientNameError = "";
  String _doctorNameError = "";
  String _specError = "";
  String _dateError = "";*/
  String _complainError = "";
  String _diagnosisError = "";
  String _treatmentError = "";

/*
  @override
  void initState() {
    super.initState();
    DoctorModel doc = context.read<DoctorModel>();

    List<SpecialityModel> mSpecList = context.read<List<SpecialityModel>>();
    print('doc ${doc.specialty}');
    print('mSpecList ${mSpecList.firstWhere((element) => element.id == doc.specialty, orElse: () => SpecialityModel(id: 'null', name: 'removed')).name}');
    selectedSpeciality = doc.specialty;
    _doctorNameController.text = doc.name;
     _specController.text =mSpecList.firstWhere((element) => element.id == doc.specialty, orElse: () => SpecialityModel(id: 'null', name: 'removed')).name;
     _dateController.text = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

  }
*/

  @override
  Widget build(BuildContext context) {
    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Add Diagnosis & Treatment',
            style: TextStyle(
                color: xColors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.width(5, context)),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*TextFormBuilder(
                  hint: "Patient Name",
                  keyType: TextInputType.text,
                  controller: _patientNameController,
                  errorText: _patientNameError,
                  enabled: false,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
                ),
                TextFormBuilder(
                  hint: "Doctor Name",
                  keyType: TextInputType.text,
                  controller: _doctorNameController,
                  errorText: _doctorNameError,
                  enabled: false,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
                ),
                TextFormBuilder(
                  hint: "Doctor Specialty",
                  keyType: TextInputType.text,
                  controller: _specController,
                  errorText: _specError,
                  enabled: false,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
                ),
                TextFormBuilder(
                  hint: "Date",
                  keyType: TextInputType.text,
                  controller: _dateController,
                  errorText: _dateError,
                  enabled: false,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
                ),*/
                TextFormBuilder(
                  hint: "Patient Symptoms",
                  keyType: TextInputType.text,
                  controller: _complainController,
                  errorText: _complainError,
                  maxLines: 3,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
                ),
                TextFormBuilder(
                  hint: "Doctor Diagnosis",
                  keyType: TextInputType.text,
                  controller: _diagnosisController,
                  errorText: _diagnosisError,
                  maxLines: 1,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
                ),
                TextFormBuilder(
                  hint: "Treatments",
                  keyType: TextInputType.text,
                  controller: _treatmentController,
                  maxLines: 4,
                  errorText: _treatmentError,
                  activeBorderColor: xColors.mainColor,
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
                      'Submit',
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
    );
  }

  void _apiRequest() async {
/*    String _patientName = _patientNameController.text;
    String _doctorName = _doctorNameController.text;
    String _spec = _specController.text;
    String _date = _dateController.text;*/
    String _complain = _complainController.text;
    String _diagnosis = _diagnosisController.text;
    String _treatment = _treatmentController.text;

    /*if (_patientName == null || _patientName.isEmpty) {
      clear();
      setState(() {
        _patientNameError = "Please enter Patient Name";
      });
    } else if (_doctorName == null || _doctorName.isEmpty) {
      clear();
      setState(() {
        _doctorNameError = "Please enter Doctor Name";
      });
    } else if (_date == null || _date.isEmpty) {
      clear();
      setState(() {
        _dateError = "Please enter Pick a Date";
      });
    } else if (_spec == null || _spec.isEmpty) {
      clear();
      setState(() {
        _specError = "Please Select Specialty";
      });
    } else*/ if (_complain == null || _complain.isEmpty) {
      clear();
      setState(() {
        _complain = "Please enter Patient Symptoms";
      });
    } else if (_diagnosis == null || _diagnosis.isEmpty) {
      clear();
      setState(() {
        _diagnosisError = "Please enter your diagnosis";
      });
    } else if (_treatment == null || _treatment.isEmpty) {
      clear();
      setState(() {
        _treatmentError = "Please enter doctor treatment";
      });
    } else {
      clear();
      //do request
      DiagnosisModel(
          patientName: '_patientName',
          complain: _complain,
          date: '_date',
          diagnosis: _diagnosis,
          doctorName: '_doctorName',
          spec: '_spec',
          treatment: _treatment);
    }
  }

  void clear() {
    setState(() {
      /*_patientNameError = "";
      _doctorNameError = "";
      _specError = "";
      _dateError = "";*/
      _complainError = "";
      _diagnosisError = "";
      _treatmentError = "";
    });
  }
}



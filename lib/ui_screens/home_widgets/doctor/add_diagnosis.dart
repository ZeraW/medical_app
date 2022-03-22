import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/ui_screens/home_widgets/patient/medical_history.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

import 'finish_examination.dart';

class AddDiagnosisScreen extends StatefulWidget {
  PatientModel patientModel;
  AppointmentModel appointmentModel;
  AddDiagnosisScreen(this.patientModel,this.appointmentModel);

  @override
  _AddDiagnosisScreenState createState() => _AddDiagnosisScreenState();
}

class _AddDiagnosisScreenState extends State<AddDiagnosisScreen> {
  TextEditingController _complainController = new TextEditingController();
  TextEditingController _diagnosisController = new TextEditingController();
  TextEditingController _treatmentController = new TextEditingController();

  String _complainError = "";
  String _diagnosisError = "";
  String _treatmentError = "";

  @override
  Widget build(BuildContext context) {
    DoctorModel doctorModel = context.watch<DoctorModel>();
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
                      if (doctorModel != null) {
                        _apiRequest(doctorModel);
                      }
                    },
                    color: xColors.mainColor,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Submit and Finish',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 10,),

                Row(children: [
                  Expanded(child: Container(color: Colors.black12,height: 3,)),
                  SizedBox(width: 10,),
                  Text('OR'),
                  SizedBox(width: 10,),
                  Expanded(child: Container(color: Colors.black12,height: 3,)),


                ],),
                SizedBox(height: 20,),

                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                     if( widget.appointmentModel.patientId!=null){
                       NavigationService.docInstance.navigateToWidget(AddFile(widget.appointmentModel.patientId));
                     }
                    },
                    color: xColors.mainColor,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Add File',
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

  void _apiRequest(DoctorModel doctorModel) async {
    String _complain = _complainController.text;
    String _diagnosis = _diagnosisController.text;
    String _treatment = _treatmentController.text;

    if (_complain == null || _complain.isEmpty) {
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
      DiagnosisModel model = DiagnosisModel(
          timestamp: DateTime.now(),
          patientName: widget.patientModel.name,
          complain: _complain,
          diagnosis: _diagnosis,
          doctorName: doctorModel.name,
          spec: doctorModel.specialty,
          treatment: _treatment);
      await DatabaseService()
          .addDiagnosis(id: widget.patientModel.id, add: model);

      AppointmentModel newAppointmentModel =  widget.appointmentModel;
      newAppointmentModel.status =1;
      newAppointmentModel.keyWords['status'] = 1;
      await DatabaseService()
          .updateAppointment(update: newAppointmentModel);
      NavigationService.docInstance.navigateToWidgetReplacement(FinishExamination(widget.appointmentModel));
    }
  }

  void clear() {
    setState(() {
      _complainError = "";
      _diagnosisError = "";
      _treatmentError = "";
    });
  }
}

import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/drop_down.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';

import '../../../models/db_model.dart';
import '../patient/medical_history.dart';
import 'add_diagnosis.dart';
import 'diagnosis_details.dart';

class PatientInfo extends StatefulWidget {
  final AppointmentModel appointmentModel;
  final PatientModel patientModel;

  const PatientInfo(this.appointmentModel, this.patientModel, {Key key})
      : super(key: key);

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  bool isDiagnosis = true;
  String type = '';
  String _typeError = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Patient Details',
            style: TextStyle(
                color: xColors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.width(5, context)),
          )),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: widget.patientModel.image != null
                      ? Image.network(
                          '${widget.patientModel.image}',
                          fit: BoxFit.cover,
                          height: 90,
                          width: 90,
                        )
                      : CircleAvatar(
                          radius: 45,child: Icon(Icons.person,size: 50,color: Colors.white,),backgroundColor: Colors.black26,
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.patientModel.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Age : ${widget.patientModel.age}',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Gender : ${widget.patientModel.gender}',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Medical History :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      isDiagnosis = true;
                      setState(() {});
                    },
                    child: Text(
                      'Diagnosis',
                      style: TextStyle(
                          color: isDiagnosis ? xColors.mainColor : null,
                          fontSize: isDiagnosis ? 18 : 17),
                    )),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () {
                      isDiagnosis = false;
                      setState(() {});
                    },
                    child: Text(
                      'Files & Tests',
                      style: TextStyle(
                          color: !isDiagnosis ? xColors.mainColor : null,
                          fontSize: !isDiagnosis ? 18 : 17),
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            !isDiagnosis? DropDownStringList(
              hint: 'Type',
              mList: ['X Rays', 'Blood Pressure','Blood Sugar','Others'],
              selectedItem: type,
              errorText: _typeError,
              onChange: (value) {
                setState(() {
                  type = value;
                });
              },
            ):SizedBox(),
            SizedBox(
              height: !isDiagnosis? 5:0,
            ),
            isDiagnosis
                ? StreamBuilder<List<DiagnosisModel>>(
                    stream: DatabaseService()
                        .getLiveDiagnosis(widget.patientModel.id),
                    builder: (context, snapshot) {
                      List<DiagnosisModel> mList = snapshot.data;

                      return Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        color: xColors.offWhite,
                        child: mList != null
                            ? ListView.builder(
                                itemCount: mList.length,
                                itemBuilder: (context, index) {
                                  return diaCard(mList[index]);
                                },
                              )
                            : SizedBox(),
                      ));
                    })
                : StreamBuilder<List<HistoryFilesModel>>(
                    stream: DatabaseService()
                        .getLiveHistoryFilesByType(widget.patientModel.id,type),
                    builder: (context, snapshot) {
                      List<HistoryFilesModel> mList = snapshot.data;

                      if(mList != null){
                        mList.sort((a,b) {
                          return   b.date.compareTo(a.date);
                        });
                      }

                      return Expanded(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        color: xColors.offWhite,
                        child: mList != null
                            ? ListView.builder(
                                itemCount: mList.length,
                                itemBuilder: (context, index) {
                                  HistoryFilesModel item = mList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      onTap: () {
                                        NavigationService.docInstance
                                            .navigateToWidget(ViewFile(item));
                                      },
                                      leading: Icon(
                                        Icons.folder_open,
                                      ),
                                      title: Text(
                                        '${item.title}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                          'Type: ${item.type}\n${item.date.day}-${item.date.month}-${item.date.year}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ));
                    }),
            Center(
              child: SizedBox(
                height: Responsive.height(7, context),
                child: ElevatedButton(
                    onPressed: () {
                      NavigationService.docInstance.navigateToWidget(
                          AddDiagnosisScreen(
                              widget.patientModel, widget.appointmentModel));
                    },
                    child: Text('Add diagnosis & treatment',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.width(4.5, context)))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget diaCard(DiagnosisModel model) {
    return InkWell(
        onTap: () {
          NavigationService.docInstance
              .navigateToWidget(DiagnosisDetailsScreen(model));
        },
        child: Card(
            child: ListTile(
          title: Text(
            '${model.diagnosis}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              'date: ${model.timestamp.day}-${model.timestamp.month}-${model.timestamp.year}'),
          trailing: Icon(Icons.keyboard_arrow_right),
        )));
  }
}

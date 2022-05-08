import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/dialogs.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/reports/all_patient_report.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:provider/provider.dart';

class AppointmentsReport extends StatefulWidget {


  @override
  State<AppointmentsReport> createState() => _AppointmentsReportState();
}

class _AppointmentsReportState extends State<AppointmentsReport> {
  bool isNew = true;

  @override
  Widget build(BuildContext context) {
    List<PatientModel> mPatientList = Provider.of<List<PatientModel>>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              InkWell(onTap: (){
                Navigator.of(context).pop();
                context.read<AdminManage>().changeAppBarTitle(title: 'Reports');

              },splashColor: Colors.transparent,hoverColor: Colors.transparent,child: Text('Reports',style: TextStyle(color: xColors.mainColor),)),Text('  /  ',),Text('Appointments Report'),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    isNew = true;
                  });
                },
                child: Card(
                    color: isNew ? xColors.mainColor : Colors.transparent,
                    elevation: isNew ?2:0,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                      child: Text(
                        'Upcoming',
                        style: TextStyle(
                            fontSize: isNew ? 20 : 18,
                            color: isNew ? Colors.white : Colors.black54),
                      ),
                    ))),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    isNew = false;
                  });
                },
                child: Card(
                  color: !isNew ? xColors.mainColor : Colors.transparent,
                  elevation: !isNew ?2:0,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                    child:Text(
                      'Past',
                      style: TextStyle(
                          fontSize: !isNew ? 20 : 18,
                          color: !isNew ? Colors.white : Colors.black54),
                    ),
                  ),
                )),
          ],
        ),
        isNew ? Expanded(
          child: AppointmentTabs(
              type: AppointmentType.UPCOMING),
        ): Expanded(
          child: AppointmentTabs(
              type: AppointmentType.PAST),
        ),

      ],)
    );
  }
}




class AppointmentTabs extends StatefulWidget {
  final AppointmentType type;

  AppointmentTabs({ @required this.type});

  @override
  _AppointmentTabsState createState() => _AppointmentTabsState();
}

class _AppointmentTabsState extends State<AppointmentTabs> {
  @override
  Widget build(BuildContext context) {
    List<PatientModel> patientList = context.watch<List<PatientModel>>();
    List<DoctorModel> mDoctorList = Provider.of<List<DoctorModel>>(context);

    return StreamBuilder<List<AppointmentModel>>(
        stream: DatabaseService().getLiveAppointmentAdmin(
            widget.type == AppointmentType.UPCOMING ? true : false),
        builder: (context, snapshot) {
          List<AppointmentModel> mList = snapshot.data;

          return mList != null && patientList != null
              ? Column(
                children: [
                  TotalCard(title: 'Appointments', description: '${mList.length}'),

                  Expanded(
                    child: ListView.builder(
                    itemBuilder: (context, index) {
                      AppointmentModel item = mList[index];
                      PatientModel patient = patientList.firstWhere(
                              (element) => element.id == item.patientId,
                          orElse: () =>
                              PatientModel(id: "null", name: "Removed"));
                      return AppointmentCard(
                        appointmentModel: item,
                        onTap: () {

                        },
                        type: widget.type,
                        docName: mDoctorList.firstWhere((element) => element.id==item.doctorId,orElse: ()=>DoctorModel(name: 'removed',id: 'null')).name,
                        date:
                        '${item.time.day}-${item.time.month}-${item.time.year}',
                        patientName: patient.name,
                      );
                    },
                    itemCount: mList.length),
                  ),
                ],
              )
              : SizedBox();
        });
  }
}

class RowCardBuilder extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  RowCardBuilder({this.title, this.value,this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$title",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "$value",
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentType type;
  final String patientName;
  final String date;
  final String docName;

  final Function onTap;
  final AppointmentModel appointmentModel;

  const AppointmentCard(
      {this.type,
        this.onTap,
        this.docName,
        @required this.appointmentModel,
        this.patientName,
        this.date,
        Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RowCardBuilder(
                    title: "Doctor Name",
                    value: "$docName",
                  ),
                  RowCardBuilder(
                    title: "Patient Name",
                    value: "$patientName",
                  ),
                  RowCardBuilder(
                    title: "Date",
                    value: "$date",
                  ),
                  appointmentModel.status > 0
                      ? RowCardBuilder(
                    title: "Status",

                    value: "${appointmentModel.status ==1 ? 'Finished' : appointmentModel.status ==2 ?'Canceled by Doctor' : 'Canceled by User'}",
                    color: appointmentModel.status ==1 ? Colors.green : appointmentModel.status ==2 ?Colors.redAccent  : Colors.orange ,
                  )
                      : SizedBox(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ButtonTheme(
                    height: 30,
                    child: type == AppointmentType.PAST
                        ? SizedBox()
                        : RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () async {
                        showDialogWithFun(
                            context: context,
                            title: 'Cancel Appointment',
                            msg:
                            'Are your sure that you want to cancel this Appointment?',
                            yes: () async {
                              AppointmentModel newAppointmentModel =
                                  appointmentModel;
                              newAppointmentModel.status = 2;
                              newAppointmentModel.keyWords['status'] = 2;
                              await DatabaseService().updateAppointment(
                                  update: newAppointmentModel);
                            });
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

/* cancelAppointment(BuildContext context) async {
    getSnackBar(context);
  }

  void getSnackBar(
      context,
      ) {
    final snackBar = SnackBar(
      content: Text("Canceled successfully"),
    );
    widget.scaffoldKey.currentState.showSnackBar(snackBar);
  }*/
}
enum AppointmentType { PAST, UPCOMING }

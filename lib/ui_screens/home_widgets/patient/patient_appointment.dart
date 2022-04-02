import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/patient_info.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

import '../../../services/database_api.dart';

class PatientAppointmentScreen extends StatefulWidget {
  @override
  _PatientAppointmentScreenState createState() =>
      _PatientAppointmentScreenState();
}

class _PatientAppointmentScreenState extends State<PatientAppointmentScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  StreamProvider<List<DoctorModel>>.value(
        value: DatabaseService().getLiveDoctor,
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: xColors.mainColor,
              title: Text(
                'My Appointments',
                style: TextStyle(
                    color: xColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.width(5, context)),
              ),
              bottom: TabBar(
                indicatorColor: Colors.grey,
                indicatorWeight: 3.0,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                tabs: <Widget>[
                  Tab(
                    icon: Text(
                      "Upcoming",
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "Past",
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                AppointmentTabs(
                    type: AppointmentType.UPCOMING,
                    scaffoldKey: _scaffoldKey),
                AppointmentTabs(
                    type: AppointmentType.PAST, scaffoldKey: _scaffoldKey)
              ],
            ),
          )),
    );
  }
}

enum AppointmentType { PAST, UPCOMING }

class AppointmentTabs extends StatefulWidget {
  final AppointmentType type;
  final scaffoldKey;

  AppointmentTabs({@required this.type, @required this.scaffoldKey});

  @override
  _AppointmentTabsState createState() => _AppointmentTabsState();
}

class _AppointmentTabsState extends State<AppointmentTabs> {
  @override
  Widget build(BuildContext context) {
    List<DoctorModel> docList = context.watch<List<DoctorModel>>();

    return StreamBuilder<List<AppointmentModel>>(
        stream: DatabaseService().getLiveAppointmentPatient(
            widget.type == AppointmentType.UPCOMING ? true : false),
        builder: (context, snapshot) {
          List<AppointmentModel> mList = snapshot.data;

          return mList != null && docList!= null? ListView.builder(
              itemBuilder: (context, index) {
                AppointmentModel item  =  mList[index];
                  return AppointmentCard(
                    type: widget.type,
                    date:'${item.time.day}-${item.time.month}-${item.time.year}',
                    status: item.status,
                    appointmentModel: item,
                    doctorName: docList
                        .firstWhere((element) =>
                    element.id == item.doctorId,
                        orElse: () => DoctorModel(id: "null", name: "Doctor Removed"))
                        .name,
                  );},
              itemCount: mList.length) : SizedBox();
        }
    );
  }


}

class AppointmentCard extends StatelessWidget {
  final AppointmentType type;
  final String doctorName;
  final String date;
  final int status;
  final AppointmentModel appointmentModel;

  const AppointmentCard({this.type, this.doctorName,this.appointmentModel,this.date,this.status, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Responsive.width(3.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                RowCardBuilder(
                  title: "Doctor Name",
                  value: "$doctorName",
                ),
                RowCardBuilder(
                  title: "Date",
                  value: "$date",
                ),
                status >0 ? RowCardBuilder(
                  title: "Status",
                  value: "${status ==1 ? 'Finished' : 'Canceled'}",
                ):SizedBox()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ButtonTheme(
                  height: Responsive.height(5.0, context),
                  child: type == AppointmentType.PAST
                      ? SizedBox()
                      : RaisedButton(
                    color: Colors.redAccent,
                    onPressed: () async{
                      AppointmentModel newAppointmentModel =  appointmentModel;
                      newAppointmentModel.status =2;
                      newAppointmentModel.keyWords['status'] = 2;
                      await DatabaseService()
                          .updateAppointment(update: newAppointmentModel);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.width(3.0, context)),
                    ),
                  ),
                )
              ],
            ),
          ],
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

class RowCardBuilder extends StatelessWidget {
  final String title;
  final String value;

  RowCardBuilder({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$title",
            style: TextStyle(fontSize: Responsive.width(3.5, context)),
          ),
          SizedBox(
            height: Responsive.height(0.8, context),
          ),
          Text(
            "$value",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.width(3.5, context)),
          )
        ],
      ),
    );
  }
}

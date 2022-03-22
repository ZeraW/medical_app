import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/patient_info.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  @override
  _DoctorAppointmentScreenState createState() => _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
              AppointmentTabs(type: AppointmentType.UPCOMING, scaffoldKey: _scaffoldKey),
              AppointmentTabs(type: AppointmentType.PAST, scaffoldKey: _scaffoldKey)
            ],
          ),
        ));
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
    List<PatientModel> patientList = context.watch<List<PatientModel>>();

    return StreamBuilder<List<AppointmentModel>>(
        stream: DatabaseService().getLiveAppointmentDoctor(
            widget.type == AppointmentType.UPCOMING ? true : false),
        builder: (context, snapshot) {
          List<AppointmentModel> mList = snapshot.data;

          return mList != null && patientList!= null? ListView.builder(
              itemBuilder: (context, index) {
                AppointmentModel item  =  mList[index];
               PatientModel patient =  patientList
                    .firstWhere((element) =>
                element.id == item.patientId,
                    orElse: () => PatientModel(id: "null", name: "Doctor Removed"));
                return AppointmentCard(
                  appointmentModel:item ,
                  onTap: (){
                    NavigationService.docInstance.navigateToWidget(PatientInfo(item,patient));
                  },
                  type: widget.type,
                  date:'${item.time.day}-${item.time.month}-${item.time.year}',
                  patientName: patient.name,
                );},
              itemCount: mList.length) : SizedBox();
        }
    );
  }


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
            style: TextStyle(fontSize: Responsive.width(3.5,context)),
          ),
          SizedBox(
            height: Responsive.height(0.8,context),
          ),
          Text(
            "$value",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.width(3.5,context)),
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
  final Function onTap;
  final AppointmentModel appointmentModel;
  const AppointmentCard({this.type, this.onTap,@required this.appointmentModel,this.patientName,this.date, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(Responsive.width(3.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RowCardBuilder(
                    title: "Patient Name",
                    value: "$patientName",
                  ),
                  RowCardBuilder(
                    title: "Date",
                    value: "$date",
                  ),

                  appointmentModel.status >0 ? RowCardBuilder(
                    title: "Status",
                    value: "${appointmentModel.status ==1 ? 'Finished' : 'Canceled'}",
                  ):SizedBox(),
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
                      onPressed: () async {
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




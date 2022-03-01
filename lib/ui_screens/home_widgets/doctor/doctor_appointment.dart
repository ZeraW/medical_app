import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/patient_info.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';

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
    return Container(child: Column(children: [
      rawCard()
    ],),);
  }

  Widget rawCard(/*MyAppointmentResponse model*/) {

    return GestureDetector(
      onTap: (){
        NavigationService.docInstance.navigateToWidget(PatientInfo());
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(Responsive.width(3.0,context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RowCardBuilder(
                    title: "Patient Name",
                    value: "Ahmed Mohamed",
                  ),
                  RowCardBuilder(
                    title: "Date",
                    value: "19-2-2022",
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ButtonTheme(
                    height: Responsive.height(5.0,context),
                    child: widget.type == AppointmentType.PAST
                        ? SizedBox()
                        : RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        cancelAppointment();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Responsive.width(3.0,context)),
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

  cancelAppointment() async {
    getSnackBar(context);
  }

  void getSnackBar(
      context,
      ) {
    final snackBar = SnackBar(
      content: Text("Canceled successfully"),
    );
    widget.scaffoldKey.currentState.showSnackBar(snackBar);
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

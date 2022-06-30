import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/dialogs.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/patient_info.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  @override
  _DoctorAppointmentScreenState createState() =>
      _DoctorAppointmentScreenState();
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
              AppointmentTabs(
                  type: AppointmentType.UPCOMING, scaffoldKey: _scaffoldKey),
              AppointmentTabs(
                  type: AppointmentType.PAST, scaffoldKey: _scaffoldKey)
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

          if (mList != null) {
            mList.sort((a, b) {
              return widget.type == AppointmentType.UPCOMING
                  ? a.time.compareTo(b.time)
                  : b.time.compareTo(a.time);
            });
          }

          return mList != null && patientList != null
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    AppointmentModel item = mList[index];
                    PatientModel patient = patientList.firstWhere(
                        (element) => element.id == item.patientId,
                        orElse: () =>
                            PatientModel(id: "null", name: "Removed"));
                    return widget.type == AppointmentType.PAST ||
                            (DateTime.now().day == item.time.day &&
                            DateTime.now().month == item.time.month &&
                            DateTime.now().year == item.time.year)
                        ? AppointmentCard(
                            appointmentModel: item,
                            onTap: () {
                              NavigationService.docInstance
                                  .navigateToWidget(PatientInfo(item, patient));
                            },
                            type: widget.type,
                            date:
                                '${item.time.day}-${item.time.month}-${item.time.year}',
                            patientName: patient.name,
                          )
                        : SizedBox();
                  },
                  itemCount: mList.length)
              : SizedBox();
        });
  }
}

class RowCardBuilder extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  RowCardBuilder({this.title, this.value, this.color});

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
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: Responsive.width(3.5, context)),
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

  const AppointmentCard(
      {this.type,
      this.onTap,
      @required this.appointmentModel,
      this.patientName,
      this.date,
      Key key})
      : super(key: key);


  String canceledByText(int x){
    switch (x) {
      case 1:return "Finished";
      case 2:return "Canceled by Doctor";
      case 3:return "Canceled by User";
      case 4:return "Canceled by Manager";

      default:
        return 'unDefinedRoute()';
    }
  }
  Color canceledByColor(int x){
    switch (x) {
      case 1:return  Colors.green;
      case 2:return Colors.redAccent;
      case 3:return Colors.orange ;
      case 4:return Colors.purpleAccent ;

      default:
        return Colors.black54;
    }
  }

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
                  appointmentModel.status > 0
                      ? RowCardBuilder(
                          title: "Status",

                    value: canceledByText(appointmentModel.status),
                    color: canceledByColor(appointmentModel.status),
                        )
                      : SizedBox(),
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

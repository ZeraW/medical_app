import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/ui_screens/home_widgets/patient/payment.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../navigation_service.dart';
import '../../../services/database_api.dart';

class DoctorScreen extends StatefulWidget {
  final DoctorModel doctor;
  final DateTime date;

  DoctorScreen({@required this.doctor, this.date});

  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  Map<String, dynamic> keyWords = {};

  @override
  Widget build(BuildContext context) {
    final String day = DateFormat('EEEE').format(widget.date);

    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<SubCityModel> mAreaList = Provider.of<List<SubCityModel>>(context);
    PatientModel model = context.watch<PatientModel>();
    return mSpecList !=null&& mCityList !=null&& mAreaList!=null? Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              NavigationService.patientInstance.goBack();
            },
            icon: Icon(Icons.arrow_back, color: Colors.black54)),
        backgroundColor: Colors.white,
        title: Text(
          'Doctor Info',
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xffF1F1F1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Color(0xffF1F1F1),
                      Colors.transparent
                    ],
                  ).createShader(
                      Rect.fromLTRB(0, 120, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  height: Responsive.width(45, context),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(widget.doctor.image),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.width(3.0, context)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: Responsive.width(2.0, context),
                        ),
                        Expanded(
                          flex: 1,
                          child: FlatButtonBuilder(
                            color: Colors.indigo,
                            icon: Icons.call,
                            labelText: "phone",
                            onTap: () {
                              makeCallPhone(widget.doctor.phone);
                            },
                          ),
                        ),
                        SizedBox(
                          width: Responsive.width(2.0, context),
                        ),
                        Expanded(
                          flex: 1,
                          child: FlatButtonBuilder(
                            onTap: () {
                              whatsApp(widget.doctor.phone);
                            },
                            color: Colors.green,
                            icon: Icons.message,
                            labelText: "Chat",
                          ),
                        ),
                        SizedBox(
                          width: Responsive.width(2.0, context),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.height(2.0, context),
                    ),
                    Text(
                      "${widget.doctor.name}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Responsive.width(6, context),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: Responsive.height(2, context),
                    ),
                    Text(
                      "${mSpecList.firstWhere((element) => element.id == widget.doctor.specialty, orElse: () => SpecialityModel(id: 'null', name: 'Removed')).name}",
                      style: TextStyle(
                          color: Colors.black,
                          wordSpacing: 1.5,
                          fontSize: Responsive.width(3.6, context),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
                    ),
                    SizedBox(
                      height: Responsive.height(1.5, context),
                    ),
                    SmoothStarRating(
                        allowHalfRating: false,
                        rating: 0,
                        onRated: (v) {},
                        starCount: 5,
                        borderColor: Colors.grey,
                        size: Responsive.width(4.5, context),
                        color: Colors.yellow[700],
                        // borderColor: Colors.red,
                        spacing: 1.0),
                    SizedBox(
                      height: Responsive.height(4, context),
                    ),
                    Text(
                      "About",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.width(4.0, context)),
                    ),
                    SizedBox(
                      height: Responsive.height(1.0, context),
                    ),
                    Text(
                      widget.doctor.about,
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.5,
                          fontSize: Responsive.width(3.3, context)),
                    ),
                    SizedBox(
                      height: Responsive.height(2.5, context),
                    ),
                    Text(
                      "Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.width(4.0, context)),
                    ),
                    SizedBox(
                      height: Responsive.height(1.0, context),
                    ),
                    Text(
                      '${widget.doctor.address} , ${mAreaList.firstWhere((element) => element.id == widget.doctor.subCity, orElse: () => SubCityModel(id: 'null', name: 'Removed')).name} , ${mCityList.firstWhere((element) => element.id == widget.doctor.city, orElse: () => CityModel(id: 'null', name: 'Removed')).name}',
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.5,
                          fontSize: Responsive.width(3.3, context)),
                    ),
                    SizedBox(
                      height: Responsive.height(2.5, context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Responsive.width(2.0, context)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          AboutDoctorSections(
                            title: "Fees",
                            value: "${widget.doctor.fees} L.E",
                          ),
                          AboutDoctorSections(
                            title: "Available",
                            value:
                                "${widget.doctor.appointments['${day}1'] != null ? DateFormat('hh:mm a').format(widget.doctor.appointments['${day}1']) : ''}",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Responsive.height(4.0, context),
                    ),
                    BottomBuilder(
                      title: "Book an appointment",
                      heightT: Responsive.height(8.0, context),
                      onTapFunction: () {
                        bookAppointment(model);
                      },
                      widthT: double.infinity,
                    ),
                    SizedBox(
                      height: Responsive.height(2.0, context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ):SizedBox();
  }

  void makeCallPhone(String phone) async {
    print('$phone');
    launch("tel://$phone");
  }

  void whatsApp(String phone) {
    if (Platform.isAndroid) {
      // add the [https]
      launch("https://wa.me/$phone"); // new line
    } else {
      // add the [https]
      launch("https://api.whatsapp.com/send?phone=$phone"); // new line
    }
  }


  void bookAppointment(PatientModel patientModel) async{
    AppointmentModel model = AppointmentModel(
        doctorId: widget.doctor.id,
        patientId: FirebaseAuth.instance.currentUser.uid,
        status: 0,
        patientName: patientModel.name,
        time: widget.date,
        keyWords: {
          'patientId': FirebaseAuth.instance.currentUser.uid,
          'doctorId': widget.doctor.id,
          'patientName':  patientModel.name,
          'time': widget.date,
          'status': 0
        });

    NavigationService.patientInstance.navigateToWidget(PaymentScreen(model: model,));


    /*await DatabaseService().addAppointment(add: model);
    NavigationService.patientInstance.goBack();*/

  }
}

class FlatButtonBuilder extends StatelessWidget {
  final Color color;
  final String labelText;
  final IconData icon;
  final Function onTap;

  FlatButtonBuilder({this.color, this.labelText, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        padding: EdgeInsets.symmetric(
            horizontal: Responsive.width(3.0, context), vertical: 13),
        onPressed: () {
          onTap();
        },
        color: color,
        //Colors.lightBlue[200],
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0)),
        icon: Icon(
          icon, // Icons.call,
          color: Colors.white,
          size: 18,
        ),
        label: Text(
          "$labelText",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }
}

class AboutDoctorSections extends StatelessWidget {
  final String title;
  final String value;

  AboutDoctorSections({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "$title",
          style: TextStyle(
              color: Colors.grey, fontSize: Responsive.width(3.5, context)),
        ),
        SizedBox(
          height: Responsive.height(0.8, context),
        ),
        Text(
          "$value",
          style: TextStyle(
              color: Colors.black,
              fontSize: Responsive.width(4.5, context),
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}

class BottomBuilder extends StatelessWidget {
  final String title;
  final Function onTapFunction;
  final double widthT;
  final double heightT;

  BottomBuilder({this.title, this.onTapFunction, this.widthT, this.heightT});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        width: widthT,
        height: heightT,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: xColors.mainColor,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Responsive.width(3.0, context),
        ),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.width(4.5, context),
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

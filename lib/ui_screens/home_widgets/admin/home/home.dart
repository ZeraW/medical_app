import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

import 'admin_screen.dart';
import '../profile_screen.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: widget.user != null
          ? Container(
              width: Responsive.width(100, context),
              child:  MultiProvider(providers: [
                      StreamProvider<List<CityModel>>.value(
                          value: DatabaseService().getLiveCities),
                      StreamProvider<List<SpecialityModel>>.value(
                          value: DatabaseService().getLiveSpeciality),
                      StreamProvider<List<DoctorModel>>.value(
                          value: DatabaseService().getLiveDoctor),
                      ChangeNotifierProvider(create: (context) => AdminManage()),
                StreamProvider<List<PatientModel>>.value(value: DatabaseService().getLivePatients),
                StreamProvider<ReportModel>.value(value: DatabaseService().getLiveReport('2022')),
                      ChangeNotifierProvider(create: (context) => DoctorManage()),
                      Provider(create: (context) => widget.user),
                      ChangeNotifierProvider(create: (context) => CityManage()),
                ChangeNotifierProvider(create: (context) => SubCityManage()),

                ChangeNotifierProvider(create: (context) => LocationsManage()),
                      ChangeNotifierProvider(create: (context) => SpecManage()),
                    ], child: AdminScreen(widget.user)))
          : SizedBox(),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/doctor_profile.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class DoctorHome extends StatefulWidget {
  DoctorHome({Key key}) : super(key: key);

  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {

  int _currentIndex = 0;
  String _pageName = 'Home';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Widget>> _childrenUser = [
      {'Home': Body()},
      {'Profile': DoctorProfile()},
    ];
    return Scaffold(
        appBar: _currentIndex ==0 ?AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: xColors.mainColor,
            title: Text(
              _pageName,
              style: TextStyle(
                  color: xColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.width(5, context)),
            )):null,
        body: _childrenUser[_currentIndex].values.first,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: _childrenUser[0].keys.first),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_pin),
                label: _childrenUser[1].keys.first),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageName = _childrenUser[index].keys.first;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          elevation: 0.0,
          selectedItemColor: xColors.white,
          backgroundColor: xColors.mainColor,
        ));
  }
}

class Body extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 4,
              child: Center(child: Image.asset('assets/images/logo_full.png'))),
          Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: SizedBox()),
                    Expanded(child: SizedBox()),
                    Expanded(child: SizedBox()),
                    Expanded(child: SizedBox()),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            onPressed: () {
                              NavigationService.docInstance.navigateTo('DoctorAppointmentScreen');

                            },
                            child: Text(
                              'My Appointments',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Responsive.width(4.5, context)),
                            ))),
                    Expanded(child: SizedBox()),
                    Expanded(
                        flex: 2,
                        child: ElevatedButton(
                            onPressed: () {
                              NavigationService.docInstance.navigateTo('ManageAppointments');
                            },
                            child: Text('Manage Appointments',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Responsive.width(4.5, context))))),
                    Expanded(child: SizedBox()),
                  ],
                ),
              )),
        ],
      );
  }
}

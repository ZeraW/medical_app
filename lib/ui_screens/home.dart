import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

import 'home_widgets/admin/home/admin_screen.dart';
import 'home_widgets/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;

  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _pageName = 'Home';

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Widget>> _childrenUser = [
      {'Home': Container()},
      {'Profile': ProfileScreen(widget.user)},
    ];

    final List<BottomNavigationBarItem> _bottomNavigation = [
      BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), label: _childrenUser[0].keys.first),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_pin), label: _childrenUser[1].keys.first),
    ];

    if (widget.user != null) {
      if (widget.user != null &&
          widget.user.type == 'admin' &&
          _currentIndex == 0) {
        _pageName = 'admin panel';
        setState(() {});
      } else if (widget.user != null &&
          widget.user.type == 'widget.user' &&
          _currentIndex == 0) {
        _pageName = 'Home';
        setState(() {});
      }
    }

    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? new AppBar(
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
              ))
          : null,
      body: widget.user != null
          ? Container(
              width: Responsive.width(100, context),
              child: widget.user != null && widget.user.type == 'admin'
                  ? MultiProvider(providers: [
                      StreamProvider<List<CityModel>>.value(
                          value: DatabaseService().getLiveCities),
                      StreamProvider<List<SpecialityModel>>.value(
                          value: DatabaseService().getLiveSpeciality),
                      StreamProvider<List<DoctorModel>>.value(
                          value: DatabaseService().getLiveDoctor),
                      ChangeNotifierProvider(
                          create: (context) => AdminManage()),
                      ChangeNotifierProvider(
                          create: (context) => DoctorManage()),
                      Provider(create: (context) => widget.user),
                      ChangeNotifierProvider(create: (context) => CityManage()),
                      ChangeNotifierProvider(
                          create: (context) => LocationsManage()),
                      ChangeNotifierProvider(create: (context) => SpecManage()),
                    ], child: AdminScreen())
                  : _childrenUser[_currentIndex].values.first)
          : SizedBox(),
      bottomNavigationBar: Responsive.isMobile(context)
          ? BottomNavigationBar(
              items: _bottomNavigation,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  _pageName = widget.user != null && widget.user.type == 'admin'
                      ? Container()
                      : _childrenUser[index].keys.first;
                });
              },
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              elevation: 0.0,
              selectedItemColor: xColors.white,
              backgroundColor: xColors.mainColor,
            )
          : null,
    );
  }
}

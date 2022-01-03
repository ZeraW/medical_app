import 'package:flutter/material.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/utils/enums.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Cities",
            press: () {
              context.read<AdminManage>().toggleWidgets(page: AdminPages.city);
            },
          ),
          DrawerListTile(
            title: "Specialities",
            press: () {
              context.read<AdminManage>().toggleWidgets(page: AdminPages.speciality);
            },
          ),
          DrawerListTile(
            title: "Doctors",
            press: () {
              context.read<AdminManage>().toggleWidgets(page: AdminPages.doctors);
            },
          ),
          DrawerListTile(
            title: "User Location",
            press: () {
              context.read<AdminManage>().toggleWidgets(page: AdminPages.locations);

            },
          ),
          DrawerListTile(
            title: "Reports",
            press: () {
              context.read<AdminManage>().toggleWidgets(page: AdminPages.reports);

            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    // For selecting those three line once press "Command+D"
     this.title,
     this.press,
  }) : super(key: key);

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(Icons.view_headline_rounded,color: Colors.white,size: 20,),
      title: Text(
        title,
        style: TextStyle(color: Colors.white,fontSize: 15),
      ),
    );
  }
}
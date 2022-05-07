import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
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
          SizedBox(height: 15,),
          Image.asset("assets/images/logo.png",width: 135,height: 135,),
          SizedBox(height: 25,),
        DrawerListTile(
        title: "Reports",
        press: () {
      NavigationService2.instance.pushReplacement('ManageReportScreen');
      context.read<AdminManage>().changeAppBarTitle(title: 'Reports');
    },
    ),
          DrawerListTile(
            title: "Cities",
            press: () {
              NavigationService2.instance.pushReplacement('ManageCitiesScreen');
              context.read<AdminManage>().changeAppBarTitle(title: 'Manage Cities');
            },
          ),
          DrawerListTile(
            title: "Specialities",
            press: () {
              NavigationService2.instance.pushReplacement('ManageSpecScreen');
              context.read<AdminManage>().changeAppBarTitle(title: 'Manage Specialities');
              },
          ),
          DrawerListTile(
            title: "Doctors",
            press: () {
              NavigationService2.instance.pushReplacement('ManageDoctorsScreen');
              context.read<AdminManage>().changeAppBarTitle(title: 'Manage Doctors');
              },
          ),
          DrawerListTile(
            title: "User Location",
            press: () {
              NavigationService2.instance.pushReplacement('ManageLocationsScreen');
              context.read<AdminManage>().changeAppBarTitle(title: 'Manage Locations');

            },
          )
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
      leading: Icon(Icons.view_headline_rounded,color: Colors.white,size: 18,),
      title: Text(
        title,
        style: TextStyle(color: Colors.white,fontSize: 13),
      ),
    );
  }
}
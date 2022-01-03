import 'package:flutter/material.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/home/components/side_menu.dart';
import 'package:provider/provider.dart';


class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // key: context.read<MenuController>().scaffoldKey,
      backgroundColor: Colors.black12,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: context.watch<AdminManage>().currentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
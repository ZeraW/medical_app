import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/routes.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/home/components/admin_logout.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/home/components/side_menu.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:medical_app/utils/themes.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {

  UserModel user;

  AdminScreen(this.user);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuController>().scaffoldKey,
      backgroundColor: Colors.black12,
      drawer: SideMenu(widget.user),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          Expanded(
            // default flex = 1
            // and it takes 1/6 part of the screen
            child: SideMenu(widget.user),
          ),

          Expanded(
              // It takes 5/6 part of the screen
              flex: 6,
              child: Column(
                children: [
                  AppBar(
                    automaticallyImplyLeading: false,
                    title: SelectableText(
                      context.select((AdminManage p) => p.title),
                      style: TextStyle(
                          fontSize: Dim.adminAppBar,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    centerTitle: false,
                    actions: [
                      StreamProvider<UserModel>.value(
                        value: DatabaseService().getUserById,
                        child: AdminLogOut(),
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  ),
                  Expanded(
                    child: MaterialApp(
                      title: widget.user.type == 'admin' ?'admin':'Manager',
                      debugShowCheckedModeBanner: false,
                      navigatorKey: NavigationService2.instance.key,
                      initialRoute: widget.user.type == 'admin' ?'ManageCitiesScreen' :'ManageReportScreen',
                      theme: appTheme(),
                      onGenerateRoute: RouteGenerator.getRoute,


                     // routes: routes,
                    ),
                  ),
                ],
              )
              //context.watch<AdminManage>().currentWidget(),
              ),
        ],
      ),
    );
  }
}

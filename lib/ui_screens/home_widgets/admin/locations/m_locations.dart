import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/locations/components/body.dart';
import 'package:provider/provider.dart';

class ManageLocationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: StreamProvider<List<HelpModel>>.value(
                value: DatabaseService().getLiveLocations(context.select((LocationsManage p) => p.isNew)),
                child: Body()),
          ),
          Expanded(
            flex: 3,
            child: context.watch<LocationsManage>().currentWidget(),
          ),
        ],
      ),
    );
  }
}

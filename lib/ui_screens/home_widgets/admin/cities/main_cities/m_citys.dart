import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/main_cities/components/body.dart';
import 'package:provider/provider.dart';

class ManageCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CityModel> mList = Provider.of<List<CityModel>>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Body(mList),
          ),
          Expanded(
            child: context.watch<CityManage>().currentWidget(),
          ),
        ],
      ),
    );
  }
}

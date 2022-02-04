import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/sub_cities/components/body.dart';
import 'package:provider/provider.dart';

class ManageSubCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    return arguments!=null ?StreamProvider(
        create: (context) => DatabaseService().getLiveSubCities(arguments['id']),
        child: AreaScreen(arguments['id'],arguments['name'],)):SizedBox();
  }
}

class AreaScreen extends StatelessWidget {
  String id,name;

  AreaScreen(this.id,this.name);

  @override
  Widget build(BuildContext context) {
    List<SubCityModel> mList = Provider.of<List<SubCityModel>>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: id!=null ?Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Body(id,name,mList),
          ),
          Expanded(
            child: context.watch<SubCityManage>().currentWidget(),
          ),
        ],
      ):SizedBox(),
    );
  }
}

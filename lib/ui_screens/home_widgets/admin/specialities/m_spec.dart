import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/home/components/admin_logout.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/specialities/components/body.dart';
import 'package:provider/provider.dart';

class ManageSpecScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SpecialityModel> mList = Provider.of<List<SpecialityModel>>(context);
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
            child: context.watch<SpecManage>().currentWidget(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/specialities/components/body.dart';
import 'package:provider/provider.dart';

class ManageSpecScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SpecialityModel> mList = Provider.of<List<SpecialityModel>>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Manage Specialities',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: false,
        ),
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
      ),
    );
  }
}

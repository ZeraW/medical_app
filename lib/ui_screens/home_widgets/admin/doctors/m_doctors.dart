import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/doctors/components/body.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/home/components/admin_logout.dart';
import 'package:provider/provider.dart';

class ManageDoctorsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<DoctorModel> mList = Provider.of<List<DoctorModel>>(context);
    List<SpecialityModel> mSpList = Provider.of<List<SpecialityModel>>(context);

    return   Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Body(mList,mSpList),
          ),
          Expanded(
            child: context.watch<DoctorManage>().currentWidget(),
          ),
        ],
      ),
    );
  }
}


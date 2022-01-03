import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/doctors/components/body.dart';
import 'package:provider/provider.dart';

class ManageDoctorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DoctorModel> mList = Provider.of<List<DoctorModel>>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Manage Doctors',
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
              child: context.watch<DoctorManage>().currentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

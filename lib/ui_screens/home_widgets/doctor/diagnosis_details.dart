import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/drop_down.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';

class DiagnosisDetailsScreen extends StatelessWidget {
  DiagnosisModel model;

  DiagnosisDetailsScreen(this.model);

  @override
  Widget build(BuildContext context) {
    List<SpecialityModel> mSpec = context.watch<List<SpecialityModel>>();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Diagnosis & Treatment',
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Patient Name'),
              subtitle: Text('${model.patientName}'),
            ),
            ListTile(
              title: Text('Doctor Name'),
              subtitle: Text('${model.doctorName}'),
            ),
            mSpec != null
                ? ListTile(
                    title: Text('Doctor Specialty'),
                    subtitle: Text(
                        '${mSpec.firstWhere((element) => element.id == model.spec, orElse: () => SpecialityModel(id: 'null', name: 'Removed')).name}'),
                  )
                : SizedBox(),
            ListTile(
              title: Text('Date'),
              subtitle: Text(
                  '${model.timestamp.day}-${model.timestamp.month}-${model.timestamp.year}'),
            ),
            ListTile(
              title: Text('Patient Symptoms'),
              subtitle: Text('${model.complain}'),
            ),
            ListTile(
              title: Text('Doctor Diagnosis'),
              subtitle: Text('${model.diagnosis}'),
            ),
            ListTile(
              title: Text('Treatments'),
              subtitle: Text('${model.treatment}'),
            ),
          ],
        ),
      ),
    );
  }
}

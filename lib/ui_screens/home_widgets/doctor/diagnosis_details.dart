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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Diagnosis & Treatment',
            style: TextStyle(
                color: xColors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.width(5, context)),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(title: Text('Patient Name'),
            subtitle: Text('name'),
            ),

            ListTile(title: Text('Doctor Name'),
              subtitle: Text('name'),
            ),

            ListTile(title: Text('Doctor Specialty'),
              subtitle: Text('Specialty'),
            ),

            ListTile(title: Text('Date'),
              subtitle: Text('22-2-2022'),
            ),

            ListTile(title: Text('Patient Symptoms'),
              subtitle: Text('Symptoms'),
            ),

            ListTile(title: Text('Doctor Diagnosis'),
              subtitle: Text('Diagnosis'),
            ),

            ListTile(title: Text('Treatments'),
              subtitle: Text('treatments'),
            ),

          ],
        ),
      ),
    );
  }


}



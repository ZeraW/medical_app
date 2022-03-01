import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';

import 'add_diagnosis.dart';
import 'diagnosis_details.dart';

class PatientInfo extends StatelessWidget {
  const PatientInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Patient Details',
            style: TextStyle(
                color: xColors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.width(5, context)),
          )),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.redAccent,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmed Mohamed',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Age : 35',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'City : Giza',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Medical History :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(5),
              color: xColors.offWhite,
              child: ListView(
                children: [
                  InkWell(
                      onTap: () {
                        NavigationService.docInstance
                            .navigateToWidget(DiagnosisDetailsScreen());
                      },
                      child: Card(
                          child: ListTile(
                        title: Text(
                          'Diagnosis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                            subtitle: Text('date: 2-2-2022'),
                            trailing: Icon(Icons.keyboard_arrow_right),
                      )))
                ],
              ),
            )),
            Center(
              child: SizedBox(
                height: Responsive.height(7, context),
                child: ElevatedButton(
                    onPressed: () {
                      NavigationService.docInstance
                          .navigateToWidget(AddDiagnosisScreen());
                    },
                    child: Text('Add diagnosis & treatment',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Responsive.width(4.5, context)))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

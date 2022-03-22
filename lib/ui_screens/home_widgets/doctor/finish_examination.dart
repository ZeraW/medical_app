import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';

class FinishExamination extends StatelessWidget {
  AppointmentModel appointmentModel;
   FinishExamination(appointmentModel,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,color: Colors.green,
              size: 150,
            ),
            SizedBox(height: 100,),
            Text('Diagnosis added Successfully',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: () async{
                    NavigationService.docInstance.goBack();
                    NavigationService.docInstance.goBack();
                },style: ButtonStyle(backgroundColor:  xColors.materialColor(xColors.mainColor)),
                child: Text('Go To Appointments',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.width(4.5, context)))),
          ],
        ),
      ),
    );
  }
}

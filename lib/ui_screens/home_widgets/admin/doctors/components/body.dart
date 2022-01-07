import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  DoctorModel doctor;

  DoctorCard({this.doctor});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              children: [
                SelectableText('${doctor.name}', style: TextStyle(fontSize: 15)),
          DropdownButton<String>(
            icon: Icon(Icons.more_vert,size: 15,),
            underline: SizedBox(),
            items: <String>['Edit'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (v) async {
                    if(v=='Edit'){
                      context.read<DoctorManage>().hideEditScreen();
                      Future.delayed(Duration(milliseconds: 25), () {
                        context.read<DoctorManage>().showEditScreen(doctor);
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final List<DoctorModel> mList;

  Body(this.mList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(2, context),
                vertical: Responsive.height(1, context)),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DoctorManage>().showAddScreen();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.add),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              xColors.materialColor(xColors.mainColor)),
                    )
                  ],
                ),
                mList != null
                    ? Expanded(
                        child: ListView(
                          children: [
                            Wrap(
                              children: mList
                                  .map((item) => DoctorCard(
                                        doctor: item
                                      ))
                                  .toList()
                                  .cast<Widget>(),
                            ),
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

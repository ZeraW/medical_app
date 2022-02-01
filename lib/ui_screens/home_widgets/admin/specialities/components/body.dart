import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/dialogs.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';

/*
class SpecialityCard extends StatelessWidget {
  SpecialityModel speciality;

  SpecialityCard({this.speciality});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
              children: [
                SelectableText('${speciality.name}', style: TextStyle(fontSize: 15)),
          DropdownButton<String>(
            icon: Icon(Icons.more_vert,size: 15,),
            underline: SizedBox(),
            items: <String>['Edit', 'Delete'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (v) async {
                    if(v=='Edit'){
                      context.read<SpecManage>().hideEditScreen();
                      Future.delayed(Duration(milliseconds: 25), () {
                        context.read<SpecManage>().showEditScreen(speciality);
                      });
                    }else if (v=='Delete'){

                      showDeleteDialog(context: context,yes: ()async{
                        context.read<SpecManage>().hideEditScreen();
                        await DatabaseService().deleteSpeciality(deleteSpeciality: speciality).then((value) =>
                            Navigator.of(context, rootNavigator: true).pop('dialog')
                        );
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
*/


class SpecialityCard extends StatelessWidget {
  SpecialityModel speciality;

  SpecialityCard({this.speciality});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Text('${speciality.name}', style: TextStyle(fontSize: 15)),
              DropdownButton<String>(
                icon: Icon(Icons.more_vert,size: 15,),
                underline: SizedBox(),
                items: <String>['Edit', 'Delete'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (v) async {
                  if(v=='Edit'){
                    context.read<SpecManage>().hideEditScreen();
                    Future.delayed(Duration(milliseconds: 25), () {
                      context.read<SpecManage>().showEditScreen(speciality);
                    });
                  }else if (v=='Delete'){

                    showDeleteDialog(context: context,yes: ()async{
                      context.read<SpecManage>().hideEditScreen();
                      await DatabaseService().deleteSpeciality(deleteSpeciality: speciality).then((value) =>
                          Navigator.of(context, rootNavigator: true).pop('dialog')
                      );
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
  final List<SpecialityModel> mList;
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
                        context.read<SpecManage>().showAddScreen();
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
                                  .map((item) => SpecialityCard(
                                        speciality: item
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

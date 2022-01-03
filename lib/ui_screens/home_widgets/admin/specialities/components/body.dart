import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/components/add_edit_cities.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class SpecialityCard extends StatelessWidget {
  SpecialityModel speciality;

  SpecialityCard({this.speciality});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 80,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child:
                      SelectableText('${speciality.name}', style: TextStyle(fontSize: 16))),
              Align(
                alignment: Alignment.topRight,
                child: DropdownButton<String>(
                  icon: Icon(Icons.more_horiz),
                  underline: Container(
                    height: 1,
                    color: Colors.transparent,
                  ),
                  items: <String>['Edit', 'Delete'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (v) async{
                    if(v=='Edit'){
                      context.read<SpecManage>().showEditScreen(speciality);
                    }else if (v=='Delete'){
                      context.read<SpecManage>().hideEditScreen();
                      await DatabaseService().deleteSpeciality(deleteSpeciality: speciality);
                    }
                  },
                ),
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
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Add Speciality',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ],
                        ),
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

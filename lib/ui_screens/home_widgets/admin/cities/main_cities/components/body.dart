import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/dialogs.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';

class CityCard extends StatelessWidget {
  CityModel city;
  Function edit, delete;

  CityCard({this.city, this.edit, this.delete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService2.instance.key.currentState.pushNamed(
            'ManageSubCitiesScreen', arguments: {'id': city.id,'name': city.name,});
        context.read<AdminManage>().changeAppBarTitle(title: '${city.name} Areas');
      },
      child: IntrinsicWidth(
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text('${city.name}', style: TextStyle(fontSize: 15)),
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
                    if (v == 'Edit') {
                      context.read<CityManage>().hideEditScreen();
                      Future.delayed(Duration(milliseconds: 25), () {
                        context.read<CityManage>().showEditScreen(city);
                      });
                    } else if (v == 'Delete') {
                      showDeleteDialog(context: context, yes: () async {
                        context.read<CityManage>().hideEditScreen();
                        await DatabaseService()
                            .deleteCity(deleteCity: city)
                            .then((value) => Navigator.of(context, rootNavigator: true).pop('dialog')
                        );
                      });
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),);
  }
}

class Body extends StatelessWidget {
  final List<CityModel> mList;

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
                        context.read<CityManage>().showAddScreen();
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
                            .map((item) =>
                            CityCard(
                              city: item,
                              edit: () async {},
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

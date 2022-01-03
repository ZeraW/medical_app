import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_screens/home_widgets/admin/cities/components/add_edit_cities.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class CityCard extends StatelessWidget {
  CityModel city;
  Function edit, delete;

  CityCard({this.city, this.edit, this.delete});

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
                      SelectableText('${city.name}', style: TextStyle(fontSize: 16))),
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
                      context.read<CityManage>().showEditScreen(city);
                    }else if (v=='Delete'){
                      await DatabaseService().deleteCity(deleteCity: city);
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
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Add City',
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
                                  .map((item) => CityCard(
                                        city: item,
                                        edit: () async {
                                        },
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

import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class SosInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person,color: Colors.white,size: 35,),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SelectableText(
                            'User Name',
                            style: TextStyle(fontSize: 27),
                          ),
                          SelectableText(
                            'Aage 65 yr',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Medical History',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.black38,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Contacts Info',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),

                              SizedBox(height: 25,),
                              ListTile(
                                leading:Icon(
                                  Icons.phone_android,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                title: SelectableText('01020304050',style: TextStyle(fontSize: 15),),
                              ),
                              SizedBox(height: 10,),
                              ListTile(
                                leading: Icon(
                                  Icons.home_outlined,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                title: SelectableText(
                                    '75M, Al Giza Desert, Giza Governorate, Egypt',style: TextStyle(fontSize: 15),),
                              ),
                              SizedBox(height: 10,),

                              ListTile(
                                onTap: (){},
                                leading: Icon(
                                  Icons.location_on_sharp,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  'Current User Location',
                                  style: TextStyle(color: Colors.blueAccent,decoration: TextDecoration.underline,fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

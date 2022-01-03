import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class LocationsCard extends StatelessWidget {
  final HelpModel location;
  LocationsCard({this.location});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> context.read<LocationsManage>().showInfoScreen(location),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            title: Text(
                '${location.user.name}', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500)),
            subtitle: Padding(
              padding:  EdgeInsets.symmetric(vertical: 8),
              child: Text(
                  'day ${location.time.day}/${location.time.month}/${location.time.year} , time (${location
                      .time.hour} : ${location.time.minute} : ${location.time.second})',
                  style: TextStyle(fontSize: 15)),
            ),
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isNew = true;
  @override
  Widget build(BuildContext context) {
    List<HelpModel> mList = Provider.of<List<HelpModel>>(context);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   GestureDetector(onTap: (){
                       setState(() {
                         isNew=true;
                       });
                       context.read<LocationsManage>().isNewChanger(false);
                   },child: Text('New',style: TextStyle(fontSize: isNew ?25:20,color: isNew ?Colors.black87:Colors.black54),)),
                    SizedBox(width: 20,),
                    GestureDetector(onTap: (){
                      setState(() {
                        isNew=false;
                      });
                      context.read<LocationsManage>().isNewChanger(true);

                    },child: Text('Old',style: TextStyle(fontSize: !isNew ?25:20,color: !isNew ?Colors.black87:Colors.black54),)),
                  ],
                ),
               SizedBox(height: 15,),
               mList != null
                    ? Expanded(
                  child: ListView(
                    children: [
                      Wrap(
                        children: mList.map((item) =>
                            LocationsCard(
                                location: item
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

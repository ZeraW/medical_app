import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/ui_screens/home_widgets/doctor/diagnosis_details.dart';
import 'package:medical_app/ui_screens/home_widgets/patient/medical_history.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SosInfo extends StatefulWidget {
  @override
  State<SosInfo> createState() => _SosInfoState();
}

class _SosInfoState extends State<SosInfo> {
  bool isDiagnosis = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationsManage>();
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: CachedNetworkImage(
                          imageUrl: "${provider.model.user.image}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            size: 90,
                            color: xColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          SelectableText(
                            'Name: ${provider.model.user.name}',
                            style: TextStyle(fontSize: 27),
                          ),
                          SelectableText(
                            'Age: ${provider.model.user.age}',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                          height: 50,
                          width: 150,
                          child: RaisedButton(
                            onPressed: () async {
                              if(!provider.model.isSolved ){
                                HelpModel update = provider.model;
                                update.isSolved = true;
                                await DatabaseService().updateSOS(sos: update);
                                provider.hideInfoScreen();
                              }
                            },
                            color: !provider.model.isSolved ? xColors.mainColor:Colors.green,
                            child: Center(
                              child: Text(
                                !provider.model.isSolved ?"Solved ?": "Solved",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                            ),
                          ))
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
                              SizedBox(
                                height: 10,
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                GestureDetector(onTap: (){
                                  isDiagnosis = true;
                                  setState(() {

                                  });
                                },child: Text('Diagnosis',style: TextStyle(color: isDiagnosis ? xColors.mainColor : null ,fontSize: isDiagnosis?18:17),)),
                                SizedBox(width: 20,),
                                GestureDetector(onTap: (){
                                  isDiagnosis = false;
                                  setState(() {

                                  });
                                },child: Text('Files',style: TextStyle(color: !isDiagnosis ? xColors.mainColor : null ,fontSize: !isDiagnosis?18:17),)),
                              ],),
                              SizedBox(
                                height: 10,
                              ),
                              isDiagnosis?  StreamBuilder<List<DiagnosisModel>>(
                                  stream: DatabaseService().getLiveDiagnosis(provider.model.user.id),
                                  builder: (context, snapshot) {
                                    List<DiagnosisModel> mList = snapshot.data;

                                    return Expanded(
                                        child: mList!=null ? ListView.builder(
                                          itemCount: mList.length,
                                          itemBuilder: (context, index) {
                                            return diaCard(mList[index]);
                                          },
                                        ):SizedBox());
                                  }
                              ):
                              StreamBuilder<List<HistoryFilesModel>>(
                                  stream: DatabaseService().getLiveHistoryFiles(provider.model.user.id),
                                  builder: (context, snapshot) {
                                    List<HistoryFilesModel> mList = snapshot.data;

                                    return Expanded(
                                        child: mList!=null ? ListView.builder(
                                          itemCount: mList.length,
                                          itemBuilder: (context, index) {
                                            HistoryFilesModel item = mList[index];
                                            return ListTile(
                                              onTap: () {
                                                NavigationService.instance
                                                    .navigateToWidget(ViewFile(item));
                                              },
                                              leading: Icon(
                                                Icons.file_open,
                                              ),
                                              title: Text(
                                                '${item.title}',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                              ),
                                              subtitle: Text(
                                                  '${item.date.day}-${item.date.month}-${item.date.year}',
                                                  style:
                                                  TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                            );
                                          },
                                        ):SizedBox());
                                  }
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
                                title: SelectableText('${provider.model.user.phone}',style: TextStyle(fontSize: 15),),
                              ),
                              SizedBox(height: 10,),

                              ListTile(
                                onTap: ()async{
                                  String url =
                                      "https://www.google.com/maps/search/?api=1&query=${provider.model.lat},${provider.model.lon}";
                                  if (await canLaunch(url)) {
                                  await launch(url, forceSafariVC: false, universalLinksOnly: true);
                                  } else {
                                  throw 'Could not launch $url';
                                  }
                                },
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

  Widget diaCard(DiagnosisModel model){
    return InkWell(
        onTap: () {
          NavigationService.instance
              .navigateToWidget(DiagnosisDetailsScreen(model));
        },
        child: Card(
            child: ListTile(
              title: Text(
                '${model.diagnosis}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('date: ${model.timestamp.day}-${model.timestamp.month}-${model.timestamp.year}'),
              trailing: Icon(Icons.keyboard_arrow_right),
            )));
  }
}

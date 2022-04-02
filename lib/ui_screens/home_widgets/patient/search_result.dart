import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../models/db_model.dart';
import '../../../navigation_service.dart';
import 'doctor_details.dart';

class SearchResult extends StatelessWidget {
  final DateTime date;
  const SearchResult({this.date,Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DoctorModel> doctorList = context.watch<List<DoctorModel>>();
    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);

    if (doctorList != null) {
      debugPrint('${doctorList.length}');
    }

    return Scaffold(
      appBar: AppBar(title: Text('Search Result'),actions: [
        IconButton(onPressed: (){
          if(doctorList !=null && mSpecList!=null)
          showSearch(context: context, delegate: DoctorSearch(doctorList,mSpecList,date));
        }, icon: Icon(Icons.search))
      ]),
      body: doctorList !=null && mSpecList!=null ?
      doctorList.isNotEmpty? ListView.builder(
        itemBuilder: (context, index) {
          return DoctorCard(doctorList[index], mSpecList,date);
        },
        itemCount: doctorList.length,
      ):Center(child: Text('No doctor found'),)
          :Center(child: CircularProgressIndicator(color: xColors.mainColor)),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorModel doctorObject;
  final List<SpecialityModel> spList;
  final DateTime date;

  DoctorCard(this.doctorObject, this.spList,this.date);

  @override
  Widget build(BuildContext context) {
    final String day = DateFormat('EEEE').format(date);

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Responsive.height(1, context),
          vertical: Responsive.height(1, context)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: 6.0,
            )
          ]),
      height: 330,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: xColors.white,
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Responsive.width(11, context)),
                    child: SizedBox(
                      height: Responsive.width(22, context),
                      width: Responsive.width(22, context),
                      child: CachedNetworkImage(
                        imageUrl: "${doctorObject.image}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Responsive.width(4, context),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${doctorObject.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.width(6, context),
                            color: xColors.mainColor),
                      ),
                      SizedBox(
                        height: Responsive.width(1, context),
                      ),
                      Text(
                        "${spList.firstWhere((element) => element.id == doctorObject.specialty, orElse: () => SpecialityModel(id: 'null', name: 'Removed')).name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Responsive.width(5, context),
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: Responsive.width(1, context),
                      ),
                      SmoothStarRating(
                          allowHalfRating: false,
                          rating: double.parse("4.5"),
                          /*  onRatingChanged: (v) {
                                                              },*/
                          starCount: 5,
                          isReadOnly: true,
                          borderColor: Colors.grey,
                          size: Responsive.width(5, context),
                          color: Colors.yellow[700],
                          // borderColor: Colors.red,
                          spacing: 0.8)
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: xColors.offWhite,
                width: double.infinity,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info_outline,color: xColors.mainColor),
                      title: Text(
                        '${doctorObject.about}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on_outlined,color: xColors.mainColor),
                      title: Text(
                        '${doctorObject.address}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.monetization_on_outlined,color: xColors.mainColor,),
                      title: Text(
                        '${doctorObject.fees}  L.E',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: Text(
                                "${doctorObject.keyWords['${day}1']!=null ?doctorObject.keyWords['${day}1']:''}"
                                    "${ doctorObject.keyWords['${day}2']!=null ? '  -  ${doctorObject.keyWords['${day}2']}' :''} ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.width(3.5, context),
                                    color: Colors.black54),
                              ),
                            )),
                        Expanded(
                            child: InkWell(
                              onTap: (){
                                NavigationService.patientInstance.navigateToWidget(DoctorScreen(doctor: doctorObject,date:date));
                              },
                              child: Container(
                          height: double.infinity,
                          color: xColors.mainColor,
                          alignment: Alignment.center,
                          child: Text(
                              "Book now",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.width(4.5, context),
                                  color: Colors.white),
                          ),
                        ),
                            )),
                      ],
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DoctorSearch extends SearchDelegate {
  List<DoctorModel> doctorList ;
  List<SpecialityModel> mSpecList;
  DateTime date;

  DoctorSearch(this.doctorList, this.mSpecList,this.date);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<DoctorModel> result = doctorList.where((f)=> f.name.toLowerCase().contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return DoctorCard(result[index], mSpecList,date);
      },
      itemCount: result.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<DoctorModel> result = doctorList.where((f)=> f.name.toLowerCase().contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return DoctorCard(result[index], mSpecList,date);
      },
      itemCount: result.length,
    );
  }
}
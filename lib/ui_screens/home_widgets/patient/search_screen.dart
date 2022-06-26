import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/navigation_service.dart';
import 'package:medical_app/ui_screens/home_widgets/patient/search_result.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/db_model.dart';
import '../../../services/database_api.dart';
import '../../../ui_components/date_picker.dart';
import '../../../ui_components/drop_down.dart';
import '../../../utils/dimensions.dart';

class QueryDoctor extends StatefulWidget {
  @override
  _QueryDoctorState createState() => _QueryDoctorState();
}

class _QueryDoctorState extends State<QueryDoctor> {
  SpecialityModel selectedSpeciality;
  SubCityModel selectedSubCity;
  CityModel selectedCity;
  String gender;
  DateTime pickedDate = DateTime.now();
  String _subCityError = "";
  String _genderError = "";
  String _cityError = "";
  String _specialtyError = "";

  @override
  Widget build(BuildContext context) {
    List<CityModel> mCityList = Provider.of<List<CityModel>>(context);
    List<SpecialityModel> mSpecList =
        Provider.of<List<SpecialityModel>>(context);

    return Scaffold(
      appBar: AppBar(

        title: Text("Search By  "),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Responsive.width(5.0, context)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            mSpecList != null
                ? DropDownDynamicList(
                    mList: mSpecList,
                    errorText: _specialtyError,
                    selectedItem: selectedSpeciality,
                    hint: "Specialty",
                    onChange: (dynamic value) {
                      setState(() {
                        selectedSpeciality = value;
                      });
                    })
                : SizedBox(),
            SizedBox(
              height: Responsive.height(3, context),
            ),
            mCityList != null
                ? DropDownDynamicList(
                    mList: mCityList,
                    errorText: _cityError,
                    selectedItem: selectedCity,
                    hint: "City",
                    onChange: (dynamic value) {
                      setState(() {
                        selectedCity = value;
                        selectedSubCity = null;
                      });
                    })
                : SizedBox(),
            SizedBox(
              height: Responsive.height(3, context),
            ),
            selectedCity != null
                ? StreamBuilder<List<SubCityModel>>(
                    stream: DatabaseService().getLiveSubCities(selectedCity.id),
                    builder: (context, snapshot) {
                      List<SubCityModel> mSubCityList = snapshot.data;
                      return mSubCityList != null
                          ? DropDownDynamicList(
                              mList: mSubCityList,
                              errorText: _subCityError,
                              selectedItem: selectedSubCity,
                              hint: "Area",
                              onChange: (dynamic value) {
                                setState(() {
                                  selectedSubCity = value;
                                });
                              })
                          : SizedBox();
                    })
                : SizedBox(),
            SizedBox(
              height: Responsive.height(selectedCity != null ? 3 : 0, context),
            ),
            DateTimePickerBuilder(
              hint: 'Pick Date',
              onChange: (value) {
                pickedDate =value;
                setState(() {

                });
              },
            ),
            SizedBox(
              height: Responsive.height(3.0, context),
            ),
            DropDownStringList(
              hint: 'Gender',
              mList: ['both','Male', 'Female'],
              selectedItem: gender,
              errorText: _genderError,
              onChange: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            SizedBox(
              height: Responsive.height(5.0, context),
            ),
            SizedBox(
              height: Responsive.height(7.0, context),
              child: RaisedButton(
                onPressed: () {
                  checkValidation();
                },
                color: xColors.mainColor,
                child: Center(
                  child: Text(
                    "Search",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: Responsive.width(5.0, context)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkValidation() {




    if (selectedSpeciality == null ) {
      clear();
      setState(() {
        _specialtyError = "Please Select Specialty";
      });
    }
    else {

      clear();
      String spec = selectedSpeciality.id;
      //do request
      //query
      final String day = DateFormat('EEEE').format(pickedDate);

      print(day);
      Query query =  FirebaseFirestore.instance
          .collection('Doctors')
          .where('keyWords.spec', isEqualTo: '$spec').where('keyWords.$day', isEqualTo: 'true');
      Query query2;
      if (selectedCity != null && selectedSubCity==null){
        String city = selectedCity.id;
        query2 = query
            .where('keyWords.city', isEqualTo: '$city');
      }else if(selectedCity != null && selectedSubCity!=null){
        String city = selectedCity.id;
        String subCity = selectedSubCity.id;

        query2 = query
            .where('keyWords.city', isEqualTo: '$city').where('keyWords.subCity', isEqualTo: '$subCity');
      }else{
        query2 = query;
      }

      Query query3;
      if (gender != null && gender.isNotEmpty && gender!='both'){
        //add gender to query
        query3 = query2.where('keyWords.gender', isEqualTo: '$gender');
      }else {
        //query without gender
        query3 = query2;
      }

        NavigationService.patientInstance.navigateToWidget(MultiProvider(providers: [
        StreamProvider<List<DoctorModel>>.value(
            value: DatabaseService().queryDoctors(query2)),
      ], child: SearchResult(date:pickedDate)));

    }
  }

  void clear() {
    setState(() {
      _genderError = "";
      _cityError = "";
      _specialtyError = "";
    });
  }
}

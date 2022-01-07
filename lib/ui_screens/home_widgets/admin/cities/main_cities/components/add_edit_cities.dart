import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';


class AddCitiesScreen extends StatefulWidget {


  @override
  _AddCitiesScreenState createState() => _AddCitiesScreenState();
}
class _AddCitiesScreenState extends State<AddCitiesScreen> {
  TextEditingController _cityNameController = new TextEditingController();
  List<CityModel> mList;

  String _cityNameError = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mList = Provider.of<List<CityModel>>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.height(1,context),
                ),

                SelectableText(
                  'Add City',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: Dim.addScreenTitle,
                      fontWeight: FontWeight.w600),
                ),

                SizedBox(
                  height: Responsive.height(2,context),
                ),
                TextFormBuilder(
                  hint: "City Name",
                  keyType: TextInputType.text,
                  controller: _cityNameController,
                  errorText: _cityNameError,
                  activeBorderColor: xColors.mainColor,

                ),
                SizedBox(
                  height: Responsive.height(3,context),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () {
                      _apiRequest();
                    },
                    color: xColors.mainColor,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Add City',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _apiRequest() async {
    String cityName = _cityNameController.text;
    if (cityName == null || cityName.isEmpty) {
      clear();
      setState(() {
        _cityNameError = "Please enter City Name";
      });
    }
    else if (!cityName.contains(new  RegExp('^[a-zA-Z]+\$'))) {
      clear();
      setState(() {
        _cityNameError = "Use only letters from a-z";
      });
    }
    else if ((mList.singleWhere((it) => it.name == cityName, orElse: () => null)) != null) {
      clear();
      setState(() {
        _cityNameError = "City Exist";
      });
    }
    else {
      clear();
      //do request
      CityModel newCity = CityModel(name: cityName);
      await DatabaseService().addCity(newCity: newCity);

      context.read<CityManage>().hideAddScreen();
    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
    });
  }
}


class EditCitiesScreen extends StatefulWidget {
  EditCitiesScreen();

  @override
  _EditCitiesScreenState createState() => _EditCitiesScreenState();
}
class _EditCitiesScreenState extends State<EditCitiesScreen> {
  TextEditingController _cityNameController = new TextEditingController();
  String _cityNameError = "";
  List<CityModel> mList;
  @override
  Widget build(BuildContext context) {
     mList = Provider.of<List<CityModel>>(context);

    if(_cityNameController.text==null || _cityNameController.text.isEmpty)
      _cityNameController.text = context.watch<CityManage>().city.name.toString();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Responsive.height(1,context),
                ),

                SelectableText(
                  'Edit City',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize:  Dim.addScreenTitle,
                      fontWeight: FontWeight.w600),
                ),

                SizedBox(
                  height: Responsive.height(2,context),
                ),
                TextFormBuilder(
                  hint: "City Name",
                  keyType: TextInputType.text,
                  controller: _cityNameController,
                  errorText: _cityNameError,
                  activeBorderColor: xColors.mainColor,

                ),
                SizedBox(
                  height: Responsive.height(3,context),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () {
                      _apiRequest();
                    },
                    color: xColors.mainColor,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Edit City',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _apiRequest() async {
    String cityName = _cityNameController.text;

     if (cityName == null || cityName.isEmpty) {
      clear();
      setState(() {
        _cityNameError = "Please enter City Name";
      });
    }else if (!cityName.contains(new  RegExp('^[a-zA-Z]+\$'))) {
       clear();
       setState(() {
         _cityNameError = "Use only letters from a-z";
       });
     }else if ((mList.singleWhere((it) => it.name == cityName, orElse: () => null)) != null) {
      clear();
      setState(() {
        _cityNameError = "City Exist";
      });
    } else {
      clear();
      //do request
      CityModel newCity = CityModel(id:context.read<CityManage>().city.id,name: cityName);
      await DatabaseService().updateCity(updatedCity: newCity);
      context.read<CityManage>().hideEditScreen();


    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
    });
  }
}




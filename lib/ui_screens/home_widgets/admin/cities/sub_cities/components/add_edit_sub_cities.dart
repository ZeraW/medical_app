import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';

class AddSubCitiesScreen extends StatefulWidget {
  @override
  _AddSubCitiesScreenState createState() => _AddSubCitiesScreenState();
}

class _AddSubCitiesScreenState extends State<AddSubCitiesScreen> {
  TextEditingController _cityNameController = new TextEditingController();
  List<SubCityModel> mList;

  String _cityNameError = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mList = Provider.of<List<SubCityModel>>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Responsive.height(1, context),
                ),
                SelectableText(
                  'Add Area',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize:  Dim.addScreenTitle,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: Responsive.height(2, context),
                ),
                TextFormBuilder(
                  hint: "Area Name",
                  keyType: TextInputType.text,
                  controller: _cityNameController,
                  errorText: _cityNameError,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
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
                      'Add Area',
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
        _cityNameError = "Please enter Area Name";
      });
    } else if (!cityName.contains(new RegExp('^[a-zA-Z]+\$'))) {
      clear();
      setState(() {
        _cityNameError = "Use only letters from a-z";
      });
    } else if ((mList.singleWhere((it) => it.name == cityName,
            orElse: () => null)) !=
        null) {
      clear();
      setState(() {
        _cityNameError = "Area Exist";
      });
    } else {
      clear();
      //do request

      if(context.read<SubCityManage>().currentCity!=null ){
        SubCityModel newSubCity = SubCityModel(
            name: cityName,
            mainCityId: context.read<SubCityManage>().currentCity);
        await DatabaseService().addSubCity(newCity: newSubCity);

        context.read<SubCityManage>().hideAddScreen();
      }
    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
    });
  }
}

class EditSubCitiesScreen extends StatefulWidget {
  EditSubCitiesScreen();

  @override
  _EditSubCitiesScreenState createState() => _EditSubCitiesScreenState();
}

class _EditSubCitiesScreenState extends State<EditSubCitiesScreen> {
  TextEditingController _cityNameController = new TextEditingController();
  String _cityNameError = "";
  List<SubCityModel> mList;

  @override
  Widget build(BuildContext context) {
    mList = Provider.of<List<SubCityModel>>(context);

    if(_cityNameController.text==null || _cityNameController.text.isEmpty)
      _cityNameController.text = context.watch<SubCityManage>().city.name.toString();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Responsive.height(1, context),
                ),
                SelectableText(
                  'Edit Area',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize:  Dim.addScreenTitle,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: Responsive.height(2, context),
                ),
                TextFormBuilder(
                  hint: "Area Name",
                  keyType: TextInputType.text,
                  controller: _cityNameController,
                  errorText: _cityNameError,
                  activeBorderColor: xColors.mainColor,
                ),
                SizedBox(
                  height: Responsive.height(3, context),
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
                      'Edit Area',
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
        _cityNameError = "Please enter Area Name";
      });
    } else if (!cityName.contains(new RegExp('^[a-zA-Z]+\$'))) {
      clear();
      setState(() {
        _cityNameError = "Use only letters from a-z";
      });
    } else if ((mList.singleWhere((it) => it.name == cityName,
            orElse: () => null)) !=
        null) {
      clear();
      setState(() {
        _cityNameError = "Area Exist";
      });
    } else {
      clear();
      //do request
      SubCityModel newSubCity = SubCityModel(
          id: context.read<SubCityManage>().city.id,
          mainCityId: context.read<SubCityManage>().city.mainCityId,
          name: cityName);
      await DatabaseService().updateSubCity(updatedCity: newSubCity);
      context.read<SubCityManage>().hideEditScreen();
    }
  }

  void clear() {
    setState(() {
      _cityNameError = "";
    });
  }
}

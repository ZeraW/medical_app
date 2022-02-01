import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/provider/admin_manage.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/ui_components/textfield_widget.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/font_size.dart';
import 'package:provider/provider.dart';


class AddScreen extends StatefulWidget {


  @override
  _AddScreenState createState() => _AddScreenState();
}
class _AddScreenState extends State<AddScreen> {
  TextEditingController _nameController = new TextEditingController();
  List<SpecialityModel>mList;
  String _nameError = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mList = Provider.of<List<SpecialityModel>>(context);

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
                  'Add Speciality',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize:  Dim.addScreenTitle,
                      fontWeight: FontWeight.w600),
                ),

                SizedBox(
                  height: Responsive.height(2,context),
                ),
                TextFormBuilder(
                  hint: "Speciality Name",
                  keyType: TextInputType.text,
                  controller: _nameController,
                  errorText: _nameError,
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
                      'Add Speciality',
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
    String name = _nameController.text;
    if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Speciality Name";
      });
    }else if (!name.contains(new  RegExp('^[a-zA-Z]+\$'))) {
      clear();
      setState(() {
        _nameError = "Use only letters from a-z";
      });
    }else if ((mList.singleWhere((it) => it.name == name, orElse: () => null)) != null) {
      clear();
      setState(() {
        _nameError = "Speciality Exist";
      });
    } else {
      clear();
      //do request
      SpecialityModel newModel = SpecialityModel(name: name);
      await DatabaseService().addSpeciality(newSpeciality: newModel);

      context.read<SpecManage>().hideAddScreen();
    }
  }

  void clear() {
    setState(() {
      _nameError = "";
    });
  }
}


class EditScreen extends StatefulWidget {
  EditScreen();

  @override
  _EditScreenState createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {
  TextEditingController _nameController = new TextEditingController();
  String _nameError = "";
  List<SpecialityModel>mList;
  @override
  Widget build(BuildContext context) {
    if(_nameController.text==null || _nameController.text.isEmpty)
    _nameController.text = context.watch<SpecManage>().model.name.toString();

    mList = Provider.of<List<SpecialityModel>>(context);

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
                  'Edit Speciality',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize:  Dim.addScreenTitle,
                      fontWeight: FontWeight.w600),
                ),

                SizedBox(
                  height: Responsive.height(2,context),
                ),
                TextFormBuilder(
                  hint: "Speciality Name",
                  keyType: TextInputType.text,
                  controller: _nameController,
                  errorText: _nameError,
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
                      'Edit Speciality',
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
    String name = _nameController.text;

     if (name == null || name.isEmpty) {
      clear();
      setState(() {
        _nameError = "Please enter Speciality Name";
      });
    } if ((mList.singleWhere((it) => it.name == name, orElse: () => null)) != null) {
      clear();
      setState(() {
        _nameError = "Speciality Exist";
      });
    }else {
      clear();
      //do request
      SpecialityModel newModel = SpecialityModel(id:context.read<SpecManage>().model.id,name: name);
      await DatabaseService().updateSpeciality(updatedSpeciality: newModel);
      context.read<SpecManage>().hideEditScreen();

    }
  }

  void clear() {
    setState(() {
      _nameError = "";
    });
  }
}




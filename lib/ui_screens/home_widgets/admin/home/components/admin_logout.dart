
import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/auth.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:provider/provider.dart';

class AdminLogOut extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context);

    return user!=null ?

    DropdownButton<String>(
      icon: Row(
        children: [
          CircleAvatar(radius: 20,backgroundColor: Colors.white,child: Icon(Icons.admin_panel_settings,color: xColors.mainColor,),),
          SizedBox(width: 15,),
          Text('${user.name}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
          SizedBox(width: 8,),
          Icon(Icons.keyboard_arrow_down,color: Colors.white,)
        ],
      ),
      underline: SizedBox(),
      dropdownColor: xColors.white,

      items: <String>['Logout'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (v)async{
        if(v=='Logout'){
         await AuthService().signOut();
        }
      },
    ) :SizedBox();
  }
}

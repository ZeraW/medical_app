import 'package:flutter/material.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';

class AdminCard extends StatelessWidget {
  String title;
  Widget open;

  AdminCard({this.title, this.open});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: Responsive.width(4.5,context)),
        ),
        leading: Icon(Icons.storage,color: xColors.mainColor, size: Responsive.width(6,context)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => open));
        },
      ),
    );
  }
}


class AdminCard2 extends StatelessWidget {
  String title;
  Function open;

  AdminCard2({this.title, this.open});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: Responsive.width(4.5,context)),
        ),
        leading: Icon(Icons.storage,color: xColors.mainColor, size: Responsive.width(6,context)),
        onTap: open,
      ),
    );
  }
}

class UsersCard extends StatelessWidget {
  String name,userId,password;
  Key key;
  Function onTap;
  UsersCard({this.name,this.userId,this.password,this.onTap, this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(

        child: SizedBox(

          width: Responsive.width(45, context),
          child: ListTile(
            onTap:  onTap,
            title: Text(
              '$name',
              style: TextStyle(fontSize: Responsive.width(4.5,context),fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '',
                  style: TextStyle(fontSize: Responsive.width(3.5,context)),
                ),
                Text(
                  '',
                  style: TextStyle(fontSize: Responsive.width(3.5,context)),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}
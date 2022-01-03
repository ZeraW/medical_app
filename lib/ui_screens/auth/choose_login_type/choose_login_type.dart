import 'package:flutter/material.dart';
import 'package:medical_app/ui_screens/auth/choose_login_type/components/body.dart';
import 'package:medical_app/utils/dimensions.dart';

class ChooseLoginType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Container(
          height: Responsive.height(55, context),
          width: Responsive.width(100, context),
          padding: EdgeInsets.all(Responsive.width(5, context)),
          child: Image.asset(
            'assets/images/logo_full.png',
          ),
        )),
        Spacer(),
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: Responsive.width(4, context)),
          // change 4 to 80 if something went wrong
          //height
          child: Responsive(
            mobile: Column(
              children: [
                UserBtn(),
                DoctorBtn(),
              ],
            ),
            desktop: AdminBtn(),
            tablet: AdminBtn(),
          ),
        ),
        SizedBox(
          height: Responsive.height(2, context),
        )
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/provider/auth_manage.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';

class CircleAssetImage extends StatelessWidget {
  final String image;

  CircleAssetImage(this.image);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Responsive.width(10, context)),
      child: Container(
        height: Responsive.width(20, context),
        width: Responsive.width(20, context),
        color: xColors.accentColor,
        child: Image.asset(
          image,
          fit: BoxFit.fitHeight,
          height: Responsive.width(60, context),
          width: Responsive.width(95, context),
        ), // replace
      ),
    );
  }
}

class ImageText extends StatelessWidget {
  final String text;

  ImageText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: xColors.white,
          fontSize: Responsive.width(6, context)),
    );
  }
}

class RoundedBtn extends StatelessWidget {
  final Widget child;
  final Function onTap;

  RoundedBtn({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          color: xColors.mainColor,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: child,
          ),
        ));
  }
}



class UserBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundedBtn(
      onTap: () {
        Provider.of<AuthManage>(context, listen: false)
            .toggleWidgets(currentPage: 1, type: "patient");
      },
      child: Row(
        children: [
          Spacer(),
          CircleAssetImage('assets/images/man.png'),
          Spacer(),
          ImageText('Patient'),
          Spacer(flex: 3,),
        ],
      ),
    );
  }
}

class DoctorBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundedBtn(
      onTap: () {
        Provider.of<AuthManage>(context, listen: false)
            .toggleWidgets(currentPage: 1, type: "doctor");
      },
      child: Row(
        children: [
          Spacer(),
          CircleAssetImage('assets/images/surgeon.png'),
          Spacer(),
          ImageText('Doctor'),
          Spacer(flex: 3,),
        ],
      ),
    );
  }
}
class AdminBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(500, 150),
      child: RoundedBtn(
        onTap: () {
          Provider.of<AuthManage>(context, listen: false)
              .toggleWidgets(currentPage: 1, type: "admin");
        },
        child: Row(
          children: [
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                height: 90,
                width: 90,
                color: xColors.accentColor,
                child: Image.asset(
                  'assets/images/administrator.png',
                  fit: BoxFit.fitHeight,
                ), // replace
              ),
            )
           ,
            Spacer(),
            Text(
              'Admin',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: xColors.white,
                  fontSize: 30),
            ),
            Spacer(flex: 3,),
          ],
        ),
      ),
    );
  }
}


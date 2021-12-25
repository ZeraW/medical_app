import 'package:flutter/material.dart';

import 'package:medical_app/ui_components/home_widgets/admin_widgets/admin_card.dart';
import 'package:medical_app/utils/dimensions.dart';


class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.width(2,context)),
      child: Column(
        children: [
          SizedBox(height: Responsive.height(1,context)),
          AdminCard(
              title: 'card',
              open: null),
        ],
      ),
    );
  }
}

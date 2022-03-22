import 'package:flutter/material.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';
import 'error_widget.dart';

class DropDownStringList extends StatelessWidget {
  final List<String> mList;
  final Function onChange;
  final String errorText,hint,selectedItem;
  final bool enableBorder;
  final bool enabled;

  DropDownStringList(
      {this.selectedItem, this.mList,this.hint, this.onChange,this.enabled = true, this.errorText,this.enableBorder=true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: enableBorder ?null:Responsive.height(3.5,context),
          padding: enableBorder ?EdgeInsets.symmetric(horizontal: Responsive.width(2,context),vertical: 1):null,
          decoration: BoxDecoration(
            border: enableBorder ?Border.all(color: Colors.black54, style: BorderStyle.solid):null,
            borderRadius: enableBorder ?BorderRadius.circular(4):null,
          ),
          child: new DropdownButton<String>(
              items: mList.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text('$hint: $value'),
                );
              }).toList(),
              dropdownColor: Colors.white,
              isExpanded: true,
              underline: SizedBox(),
              icon: enabled ?Icon(Icons.keyboard_arrow_down,color: xColors.mainColor,):SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '$hint : $selectedItem'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  xColors.mainColor,fontSize: Responsive.isMobile(context)?Responsive.width(4,context):17),
              ),
              onChanged: enabled ? onChange: null),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}


class DropDownDynamicList extends StatelessWidget {
  final dynamic selectedItem;
  final List<dynamic> mList;
  final Function onChange;
  final String hint;
  final String errorText;
  final bool enabled;

  DropDownDynamicList(
      {this.selectedItem, this.mList,this.hint, this.onChange,this.enabled = true, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Responsive.width(2,context),vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<dynamic>(

              items: mList.map((dynamic value) {
                return new DropdownMenuItem<dynamic>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              dropdownColor: Colors.white,
              icon: enabled ? Icon(Icons.keyboard_arrow_down,color: xColors.mainColor,) :SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '$hint : ${selectedItem.name}'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  xColors.mainColor,fontSize: Responsive.isMobile(context)?Responsive.width(4,context):17),
              ),
              onChanged: enabled ? onChange : null),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}


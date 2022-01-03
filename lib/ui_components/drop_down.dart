import 'package:flutter/material.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';
import 'error_widget.dart';

class DropDownStringList extends StatelessWidget {
  final List<String> mList;
  final Function onChange;
  final String errorText,hint,selectedItem;
  final bool enableBorder;

  DropDownStringList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText,this.enableBorder=true});

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
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down,color: xColors.mainColor,),
              hint: Text(
                selectedItem != null
                    ? '$hint : $selectedItem'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  xColors.mainColor,fontSize: Responsive.isMobile(context)?Responsive.width(4,context):17),
              ),
              onChanged: onChange),
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

  DropDownDynamicList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText});

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
              icon: Icon(Icons.keyboard_arrow_down,color: xColors.mainColor,),

              hint: Text(
                selectedItem != null
                    ? '$hint : ${selectedItem.name}'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  xColors.mainColor,fontSize: Responsive.isMobile(context)?Responsive.width(4,context):17),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}


/*




class DropDownClassList extends StatelessWidget {
  final ClassModel selectedItem;
  final List<ClassModel> mList;
  final Function onChange;
  final String hint;
  final String errorText;
  final bool enableBorder;

  DropDownClassList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText,this.enableBorder=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          height: enableBorder ?Dimensions.getHeight(4):null,

          padding: enableBorder ?null:EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: enableBorder ?null:Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: enableBorder ?null:BorderRadius.circular(4),
          ),
          child: new DropdownButton<ClassModel>(
              items: mList.map((ClassModel value) {
                return new DropdownMenuItem<ClassModel>(
                  value: value,
                  child: new Text('${value.className}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down,color: Uti().mainColor,),

              hint: Align(
                alignment: enableBorder ?Alignment.center:Alignment.centerLeft,
                child: Text(
                  selectedItem != null
                      ? '$hint: ${selectedItem.className}'
                      : 'Choose $hint',
                  style: TextStyle(
                      color:  Uti().mainColor,fontSize: Dimensions.getWidth(4)),
                ),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}


class DropDownCarList extends StatelessWidget {
  final CarModel selectedItem;
  final List<CarModel> mList;
  final Function onChange;
  final String hint;
  final String errorText;

  DropDownCarList(
      {this.selectedItem, this.mList,this.hint, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<CarModel>(
              items: mList.map((CarModel value) {
                return new DropdownMenuItem<CarModel>(
                  value: value,
                  child: new Text('${value.carNumber}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? '${selectedItem.carNumber}'
                    : 'Choose $hint',
                style: TextStyle(
                    color:  Uti().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}

class DropDownTrainList extends StatelessWidget {
  final TrainModel selectedItem;
  final List<TrainModel> mList;
  final Function onChange;
  final String errorText;

  DropDownTrainList(
      {this.selectedItem, this.mList, this.onChange, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(2)),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(4),
          ),
          child: new DropdownButton<TrainModel>(
              items: mList.map((TrainModel value) {
                return new DropdownMenuItem<TrainModel>(
                  value: value,
                  child: new Text('${value.name}'),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                selectedItem != null
                    ? 'Train: ${selectedItem.name}'
                    : 'Choose Train',
                style: TextStyle(
                    color:  Uti().mainColor,fontSize: Dimensions.getWidth(4)),
              ),
              onChanged: onChange),
        ),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}
*/

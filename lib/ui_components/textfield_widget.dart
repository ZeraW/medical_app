import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';


import 'error_widget.dart';

class TextFormBuilder extends StatelessWidget {
  final String hint;
  final TextInputType keyType;
  final bool isPassword,enabled;
  final TextEditingController controller;
  final String errorText;
  final int maxLength;
  final Color activeBorderColor;

  TextFormBuilder(
      {this.hint,
      this.keyType,
      this.isPassword,
      this.controller,
      this.errorText,
        this.maxLength,
        this.enabled =true,
      this.activeBorderColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(

            maxLength: maxLength,
            controller: controller,
            style: TextStyle(fontSize: Responsive.isMobile(context) ?Responsive.width(2,context):17),
            validator: (value) {
              if (value.isEmpty) {
                return "Please Enter a valid text";
              }
              return null;
            },
            enabled: enabled,
            //controller: _controller,
            maxLines: 1,

            //onChanged: onChange,
            keyboardType: keyType != null ? keyType : TextInputType.text,
            obscureText: isPassword != null ? isPassword : false,
            decoration: InputDecoration(
              labelText: '$hint',
              labelStyle: TextStyle(
                  color: activeBorderColor ?? xColors.mainColor,
                  fontSize: Responsive.isMobile(context) ?Responsive.width(3.5,context):17),
              hintText: "$hint",
              hintStyle: TextStyle(
                  color: activeBorderColor ?? xColors.hintColor,
                  fontSize: Responsive.isMobile(context) ?Responsive.width(3.5,context) : 17),
              contentPadding: new EdgeInsets.symmetric(
                  vertical: Responsive.height(2.5,context),
                  horizontal: Responsive.width(2.0,context)),
              focusedErrorBorder: new OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: xColors.mainColor),
              ),
              errorStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500),
              focusedBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: activeBorderColor ?? xColors.mainColor),
              ),
              errorBorder: new OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: Theme.of(context).accentColor),
              ),
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Colors.black54, style: BorderStyle.solid),
              ),
              disabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Colors.black54, style: BorderStyle.solid),
              ),
              fillColor: Colors.white,
            )),
        errorText != null
            ? GetErrorWidget(isValid: errorText != "", errorText: errorText)
            : SizedBox()
      ],
    );
  }
}

class CleanTextField extends StatelessWidget {
  final String hint;
  final TextInputType keyType;
  final TextEditingController controller;
  final int maxLength;

  CleanTextField(
      {this.hint,
        this.keyType,
        this.controller,
        this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(

            //maxLength: maxLength,
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return "Please Enter a valid text";
              }
              return null;
            },
            maxLines: 1,

            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              LimitRangeTextInputFormatter(0, 100),
            ],

            //onChanged: onChange,
            keyboardType: keyType != null ? keyType : TextInputType.text,
            decoration: InputDecoration(
              hintText: "$hint",
              counterText: "",
              hintStyle: TextStyle(
                  color:  xColors.hintColor,
                  fontSize: Responsive.width(3.5,context)),
              contentPadding: new EdgeInsets.symmetric(
                  vertical: Responsive.height(1.0,context),
                  horizontal: Responsive.width(4.0,context)),
              focusedErrorBorder: new OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: xColors.mainColor),
              ),
              errorStyle: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500),
              focusedBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: xColors.mainColor),
              ),
              errorBorder: new OutlineInputBorder(
                borderSide:
                BorderSide(width: 1, color: Theme.of(context).accentColor),
              ),
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Colors.black54, style: BorderStyle.solid),
              ),
              disabledBorder: new OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1, color: Colors.black54, style: BorderStyle.solid),
              ),
              fillColor: Colors.white,
            )),
      ],
    );
  }
}


class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max) : assert(min < max);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    var value = newValue.text!=null && newValue.text.isNotEmpty ?int.parse(newValue.text) :0;
    if (value < min) {
      return TextEditingValue(text: min.toString());
    } else if (value > max&& value!=max) {
      return TextEditingValue(text: max.toString());
    }
    return newValue;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:medical_app/utils/colors.dart';
/*
import 'package:email_validator/email_validator.dart';
*/


import 'error_widget.dart';

class TextFormBuilder extends StatefulWidget {
  final String hint;
  final TextInputType keyType;
  final bool isPassword,enabled;
  final TextEditingController controller;
  String errorText;
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
  _TextFormBuilderState createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(

            maxLength: widget.maxLength,
            controller: widget.controller,
            style: TextStyle(fontSize: Responsive.isMobile(context) ?Responsive.width(2,context):17),
            validator: (value) {
              if (value.isEmpty) {
                return "Please Enter a valid text";
              }
              return null;
            },
            enabled: widget.enabled,
            //controller: _controller,
            maxLines: 1,
            //onChanged: onChange,
            keyboardType: widget.keyType != null ? widget.keyType : TextInputType.text,
            obscureText: widget.isPassword != null ? widget.isPassword : false,
            onChanged: (v){
              setState(() {
                widget.errorText ='';
              });
            },
            decoration: InputDecoration(
              labelText: '${widget.hint}',
              labelStyle: TextStyle(
                  color: widget.activeBorderColor ?? xColors.mainColor,
                  fontSize: Responsive.isMobile(context) ?Responsive.width(3.5,context):17),
              hintText: "${widget.hint}",
              hintStyle: TextStyle(
                  color: widget.activeBorderColor ?? xColors.hintColor,
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
                    width: 1, color: widget.activeBorderColor ?? xColors.mainColor),
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
        widget.errorText != null
            ? GetErrorWidget(isValid: widget.errorText != "", errorText: widget.errorText)
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


class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  String errorText;

   PasswordFieldWidget({
    Key key,
     this.controller,
    this.hint,
    this.errorText
  }) : super(key: key);

  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextFormField(
        controller: widget.controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          labelText: '${widget.hint}',
          labelStyle: TextStyle(
              color:  xColors.mainColor,
              fontSize: Responsive.isMobile(context) ?Responsive.width(3.5,context):17),
          hintText: "${widget.hint}",
          hintStyle: TextStyle(
              color:xColors.hintColor,
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

          suffixIcon: IconButton(
            icon:
            isHidden ? Icon(Icons.visibility_off,color: Colors.grey,) : Icon(Icons.visibility,color: xColors.mainColor,),
            onPressed: togglePasswordVisibility,
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        autofillHints: [AutofillHints.password],
        onChanged: (v){
          setState(() {
            widget.errorText ='';
          });
        },
        onEditingComplete: () => TextInput.finishAutofillContext(),
        validator: (password) => password != null && password.length < 6
            ? 'Enter min. 6 characters'
            : null,
      ),
      widget.errorText != null
          ? GetErrorWidget(isValid: widget.errorText != "", errorText: widget.errorText)
          : SizedBox()
    ],
  );

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}


class EmailFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const EmailFieldWidget({
    Key key,
     this.controller,
  }) : super(key: key);

  @override
  _EmailFieldWidgetState createState() => _EmailFieldWidgetState();
}

class _EmailFieldWidgetState extends State<EmailFieldWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    decoration: InputDecoration(
      hintText: 'Email',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      prefixIcon: Icon(Icons.mail),
      suffixIcon: widget.controller.text.isEmpty
          ? Container(width: 0)
          : IconButton(
        icon: Icon(Icons.close),
        onPressed: () => widget.controller.clear(),
      ),
    ),
    keyboardType: TextInputType.emailAddress,
    autofillHints: [AutofillHints.email],
    autofocus: true,
/*    validator: (email) => email != null && EmailValidator.validate(email)
        ? 'Enter a valid email'
        : null,*/
  );
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
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'package:intl/intl.dart';


class DateTimePickerBuilder extends StatefulWidget {
  final String hint;
  final bool enabled;

  final TextEditingController controller;
  final Color activeBorderColor;
  final FocusNode focusNode;
  final Function(DateTime) onChange;

  final FormFieldValidator<DateTime> validator;
  const DateTimePickerBuilder(
      { this.hint,
         this.controller,
        this.focusNode,
        this.validator,
        this.onChange,
        this.enabled =true,
        this.activeBorderColor,Key key}) : super(key: key);

  @override
  _DateTimePickerBuilderState createState() => _DateTimePickerBuilderState();
}
class _DateTimePickerBuilderState extends State<DateTimePickerBuilder> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
        name: widget.hint,
        initialValue: DateTime.now(),
        enabled: widget.enabled,
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChange,
        maxLines: 1,
        alwaysUse24HourFormat: false,
        firstDate: DateTime.now(),
        inputType: InputType.date,
        lastDate: DateTime(2024),
        validator: widget.validator,
        format: DateFormat('M/d/yyyy'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: widget.hint,
          labelStyle: TextStyle(
              color: widget.activeBorderColor ?? xColors.mainColor,
              fontSize: 16),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: widget.activeBorderColor ?? xColors.hintColor,
              fontSize: 16),
          contentPadding: EdgeInsets.symmetric(
              vertical: Responsive.height(2.5,context),
              horizontal: Responsive.width(2.0,context)),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: xColors.mainColor),
          ),
          errorStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: widget.activeBorderColor ?? xColors.mainColor),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide:
            BorderSide(width: 1, color: Colors.redAccent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Colors.black54, style: BorderStyle.solid),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                width: 1, color: Colors.black54, style: BorderStyle.solid),
          ),
          fillColor: Colors.white,
        ));
  }
}

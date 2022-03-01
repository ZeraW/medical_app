import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class ManageAppointments extends StatefulWidget {
  @override
  _ManageAppointmentsState createState() => _ManageAppointmentsState();
}

class _ManageAppointmentsState extends State<ManageAppointments> {
  /*Map<String, DateTime> appointments = {};
  Map<String, String> keyWords = {};*/

  @override
  Widget build(BuildContext context) {
    DoctorModel doc = Provider.of<DoctorModel>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Manage Appointments',
            style: TextStyle(
                color: xColors.white,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.width(5, context)),
          )),
      body:doc!=null ? SingleChildScrollView(
        child: Column(
          children: [DateTile(day:'Saturday',doc: doc ,),
            DateTile(day:'Sunday',doc: doc ,),
            DateTile(day:'Monday',doc: doc ,),
            DateTile(day:'Tuesday',doc: doc ,),
            DateTile(day:'Wednesday',doc: doc ,),
            DateTile(day:'Thursday',doc: doc ,),
            DateTile(day:'Friday',doc: doc ,),
          ],
        ),
      ):SizedBox(),
    );
  }
}


class DateTile extends StatefulWidget {
  DoctorModel doc;
  String day;
   DateTile({this.doc,this.day,Key key}) : super(key: key);


  @override
  _DateTileState createState() => _DateTileState();
}

class _DateTileState extends State<DateTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor: xColors.textColor,
      textColor: xColors.mainColor,
      iconColor: xColors.mainColor,
      collapsedIconColor: xColors.textColor,
      children: [
        widget.doc.keyWords['${widget.day}'] == null || widget.doc.keyWords['${widget.day}'] != 'false'
            ? Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Text('Start At : '),
            TextButton(
                onPressed: () {
                  DatePicker.showTime12hPicker(context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                          backgroundColor: Colors.white,
                          headerColor: Colors.white),
                      onConfirm: (date) async {
                        int hour = date.hour == 0
                            ? 12
                            : (date.hour > 12
                            ? date.hour - 12
                            : date.hour);
                        String amPm = date.hour == 12
                            ? 'PM'
                            : (date.hour > 12 ? 'PM' : 'Am');
                        print('$hour:${date.minute} $amPm');

                        await DatabaseService().doctorsCollection.doc(widget.doc.id).update({
                          'keyWords.${widget.day}': 'true',
                          'keyWords.${widget.day}1': '$hour:${date.minute} $amPm',
                          'appointments.${widget.day}1': date,
                        });

                      }, locale: LocaleType.en);
                },
                child: Text(
                  widget.doc.keyWords['${widget.day}1'] != null
                      ? widget.doc.keyWords['${widget.day}1']
                      : 'Pick Time',
                  style: TextStyle(color: Colors.blue),
                )),
            Spacer(),
            Text('End At : '),
            TextButton(
                onPressed: () {
                  DatePicker.showTime12hPicker(context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                          backgroundColor: Colors.white,
                          headerColor: Colors.white),
                      onConfirm: (date) async{
                        int hour = date.hour == 0
                            ? 12
                            : (date.hour > 12
                            ? date.hour - 12
                            : date.hour);
                        String amPm = date.hour == 12
                            ? 'PM'
                            : (date.hour > 12 ? 'PM' : 'Am');
                        print('$hour:${date.minute} $amPm');
                        await DatabaseService().doctorsCollection.doc(widget.doc.id).update({
                          'keyWords.${widget.day}': 'true',
                          'keyWords.${widget.day}2': '$hour:${date.minute} $amPm',
                          'appointments.${widget.day}2': date,
                        });
                      }, locale: LocaleType.en);
                },
                child: Text(
                  widget.doc.keyWords['${widget.day}2'] != null
                      ? widget.doc.keyWords['${widget.day}2']
                      : 'Pick Time',
                  style: TextStyle(color: Colors.blue),
                )),
            SizedBox(
              width: 15,
            ),
          ],
        )
            : SizedBox(),
        ElevatedButton(
            onPressed: () async{
              if (widget.doc.keyWords['${widget.day}'] == null ||
                  widget.doc.keyWords['${widget.day}'] != 'false') {

                await DatabaseService().doctorsCollection.doc(widget.doc.id).update({
                  'keyWords.${widget.day}': 'false',
                });
              } else {
               // widget.doc.keyWords['${widget.day}'] = 'true';

                await DatabaseService().doctorsCollection.doc(widget.doc.id).update({
                  'keyWords.${widget.day}': 'true',
                });
              }
            },
            style: ButtonStyle(
                backgroundColor: xColors.materialColor(
                    widget.doc.keyWords['${widget.day}'] == null ||
                        widget.doc.keyWords['${widget.day}'] != 'false'
                        ? Colors.redAccent
                        : xColors.mainColor)),
            child: Text(widget.doc.keyWords['${widget.day}'] == null ||
                widget.doc.keyWords['${widget.day}'] != 'false'
                ? 'Day Off ?'
                : 'Work day'))
      ],
      title: Text('${widget.day}'),
    );
  }
}

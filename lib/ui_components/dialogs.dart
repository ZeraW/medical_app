import 'package:flutter/material.dart';

showDeleteDialog({BuildContext context, Function yes}) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  ()=>Navigator.of(context, rootNavigator: true).pop('dialog'),
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  yes,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Item"),
    content: Text("Would you like to continue deleting this item?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showDialogWithFun({BuildContext context,String title,String msg, Function yes}) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  ()=>Navigator.of(context, rootNavigator: true).pop('dialog'),
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed:  (){
      yes();
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("$title"),
    content: Text("$msg"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
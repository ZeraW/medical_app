import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:medical_app/utils/dimensions.dart';

import '../../../navigation_service.dart';
import '../../../services/database_api.dart';

class PaymentScreen extends StatefulWidget {
  AppointmentModel model;

  PaymentScreen({this.model});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCash = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: xColors.mainColor,
          title: Text(
            'Payment Details',
          )),
      body: Container(
        height: Responsive.height(100, context),
        width: Responsive.width(100, context),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilderRadioGroup(
                  decoration: InputDecoration(
                      labelText: 'Pay With',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  name: 'my_language',
                  activeColor: Colors.indigoAccent,
                  initialValue: 'Cash',
                  onChanged: (p){
                    setState(() {
                      p == 'Cash' ? isCash = true : isCash=false;
                    });
                  },
                  orientation: OptionsOrientation.vertical,
                  options: [
                    'Cash',
                    'Credit Card',
                  ]
                      .map((lang) => FormBuilderFieldOption(value: lang))
                      .toList(growable: false),
                ),
              ),
              !isCash? CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ):SizedBox(),
              !isCash? Column(
                children: [
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumberDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Expired Date',
                      hintText: 'XX/XX',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Card Holder',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                    cvvCode: '',
                    cardNumber: '',
                    expiryDate: '',
                    themeColor: xColors.mainColor,
                    cardHolderName: '',
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IntrinsicWidth(
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'halter',
                            fontSize: 14,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                    ),
                    color: xColors.mainColor,
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        await DatabaseService()
                            .addAppointment(add: widget.model);
                        NavigationService.patientInstance.goBack();
                        NavigationService.patientInstance.goBack();
                        NavigationService.patientInstance.goBack();
                        NavigationService.patientInstance.goBack();

                        NavigationService.patientInstance
                            .navigateTo('PatientAppointmentScreen');
                        const snackBar = SnackBar(
                          content: Text('Booked successfully'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),

                ],
              ):SizedBox(),
              SizedBox(height: 10,),
              isCash? RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IntrinsicWidth(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(8),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'halter',
                        fontSize: 14,
                        package: 'flutter_credit_card',
                      ),
                    ),
                  ),
                ),
                color: xColors.mainColor,
                onPressed: () async {
                  await DatabaseService()
                      .addAppointment(add: widget.model);

                  NavigationService.patientInstance.goBack();
                  NavigationService.patientInstance.goBack();
                  NavigationService.patientInstance.goBack();
                  NavigationService.patientInstance.goBack();

                  NavigationService.patientInstance
                      .navigateTo('PatientAppointmentScreen');
                  const snackBar = SnackBar(
                    content: Text('Booked successfully'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                },
              ):SizedBox(),

            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

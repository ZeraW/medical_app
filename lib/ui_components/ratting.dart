
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medical_app/models/db_model.dart';

import '../services/database_api.dart';

class DoRate {

  rate(BuildContext context,DoctorModel doctor){
    double rate =0.0;
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, setStatex) {
          return AlertDialog(
            title: Text('Rate ${doctor.name}'),
            content: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.green,
              ),
              onRatingUpdate: (rating) {
                rate = rating;
                setStatex((){});
              },
            ),
            actions: [Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              TextButton(onPressed: (){
                print('$rate');
                _rateTheRestaurant(context,doctor,rate.round());
              }, child: Text('Rate',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600))),
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel',style: TextStyle(color: Colors.grey),))
            ],)],
          );
        }));
  }


  _rateTheRestaurant(BuildContext context,DoctorModel doctor,int rate)async{

    await DatabaseService().rateDoctor(docId: doctor.id,ratting: rate);

    Navigator.pop(context);

  }



}
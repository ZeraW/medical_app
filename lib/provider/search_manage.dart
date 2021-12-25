/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/db_model.dart';

class SearchManage extends ChangeNotifier {
  Query queryRef;
  String source, destination, date, trainType;

  ClassModel carClass;
  bool foodDrink;

  SearchManage(
      {this.source,
      this.destination,
      @required this.date,
      this.trainType,
      this.carClass,
      this.foodDrink});

  void updateQuery() {
    print(carClass.id);
    if (trainType != null) {
      if (trainType == 'Super Fast') {
        queryRef = FirebaseFirestore.instance
            .collection('Trips')
            .orderBy('keyWords.date')
            .where('keyWords.${carClass.id}', isEqualTo: 'ture')
            .where('keyWords.trainType', isEqualTo: 'Super Fast');
        if (source != null && destination == null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .orderBy('keyWords.date')
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.${carClass.id}', isEqualTo: 'ture')
              .where('keyWords.cityfrom', isEqualTo: source);
        } else if (destination != null && source == null) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .orderBy('keyWords.date')
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.${carClass.id}', isEqualTo: 'ture')
              .where('keyWords.cityto', isEqualTo: destination);
        } else {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .orderBy('keyWords.date')
              .where('keyWords.trainType', isEqualTo: 'Super Fast')
              .where('keyWords.cityfrom', isEqualTo: source)
              .where('keyWords.${carClass.id}', isEqualTo: 'ture')
              .where('keyWords.cityto', isEqualTo: destination);

        }
      } else if (trainType == 'Express') {
        if (int.parse(source) < int.parse(destination)) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.trainType', isEqualTo: 'Express')
              .where('source', isLessThan: int.parse(destination))
              .where('keyWords.${carClass.id}', isEqualTo: 'ture')
              .where('keyWords.city$source', isEqualTo: 'true')
              .where('keyWords.city$destination', isEqualTo: 'true');
        } else if (int.parse(source) > int.parse(destination)) {
          queryRef = FirebaseFirestore.instance
              .collection('Trips')
              .where('keyWords.trainType', isEqualTo: 'Express')
              .where('source', isGreaterThan: int.parse(destination))
              .where('keyWords.${carClass.id}', isEqualTo: 'ture')
              .where('keyWords.city$source', isEqualTo: 'true')
              .where('keyWords.city$destination', isEqualTo: 'true');
        }
      }
    }

    notifyListeners();
  }

  void updateSource(String newSource) {
    source = newSource;
    updateQuery();
  }

  void updateDestination(String newDestination) {
    destination = newDestination;
    updateQuery();
  }

  void swapSourceWithDestination() {
    String holder;
    holder = source;
    source = destination;
    destination = holder;
    updateQuery();
  }
}
*/

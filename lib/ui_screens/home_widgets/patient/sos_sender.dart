import 'package:flutter/material.dart';
import 'package:medical_app/models/db_model.dart';
import 'package:medical_app/services/database_api.dart';
import 'package:medical_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';

class SosSender extends StatelessWidget {
  const SosSender({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PatientModel user = Provider.of<PatientModel>(context);

    return Positioned.fill(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.local_hospital_outlined,
                    size: 45,
                    color: Colors.black54,
                  ),
                  padding: EdgeInsets.zero,
                  splashColor: Colors.black12,
                  splashRadius: 24,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("SOS"),
                            content: Text(
                                "Are you in need of medical assistance right now?"),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.green),
                                ),
                                onPressed: () async {
                                  if (user != null) {
                                    try {
                                      Position p = await GeolocatorService()
                                          .determinePosition();
                                      print('$p');
                                      print('lat ${ p.latitude}');
                                      print('lon ${ p.longitude}');

                                      HelpModel newSOS = HelpModel(
                                          time: DateTime.now(),
                                          isSolved: false,
                                          lat: p.latitude.toString(),
                                          lon: p.longitude.toString(),
                                          user: user);
                                      await DatabaseService().addSOS(newSOS: newSOS).then((value) {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');

                                        Toast.show(
                                            "Help is on the way", context,
                                            backgroundColor: Colors.black54,
                                            duration: Toast.LENGTH_LONG + 2,
                                            gravity: Toast.CENTER);
                                      });

                                    } catch (e) {
                                      Toast.show("$e", context,
                                          backgroundColor: Colors.red,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    }


                                  }



                                },
                              ),
                              TextButton(
                                child: Text(
                                  "no",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black54),
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                },
                              ),
                            ],
                          );
                        });
                  },
                ))));
  }
}

class GeolocatorService {
  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location Permission denied Forever');
      }
      throw Exception('Location Permission denied');
    } else {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }
}

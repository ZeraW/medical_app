import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

import '../models/db_model.dart';

class DatabaseService {
  // Users collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference citiesCollection =
  FirebaseFirestore.instance.collection('Cities');
  final CollectionReference subCitiesCollection =
  FirebaseFirestore.instance.collection('SubCities');

  final CollectionReference specialityCollection =
  FirebaseFirestore.instance.collection('Speciality');

  final CollectionReference doctorsCollection =
  FirebaseFirestore.instance.collection('Doctors');

  final CollectionReference sosCollection =
  FirebaseFirestore.instance.collection('SOS');

  // --------------------- User --------------------- //
  //get my user
  Stream<UserModel> get getUserById {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()));
  }

  Stream<UserModel>  getUser(String id) {
    return userCollection
        .doc(id)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()));
  }


  //upload Image method
  Future uploadImageToStorage({ File file, String id}) async {
    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref('images/$id.png');

    firebase_storage.UploadTask task = ref.putFile(file);

    // We can still optionally use the Future alongside the stream.
    try {
      //update image
      await task;
      String url = await FirebaseStorage.instance
          .ref('images/$id.png')
          .getDownloadURL();

      return url;
    } on firebase_storage.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  //updateUserData
  Future<void> updateUserData({UserModel user}) async {
    return await userCollection.doc(user.id).set(user.toJson());
  }

  // --------------------- User --------------------- //


  /// --------------------- City --------------------- ///
  //add new City
  Future addCity({CityModel newCity}) async {
    var ref = citiesCollection.doc();
    newCity.id = ref.id;
    return await ref.set(newCity.toJson());
  }

  //update existing City
  Future updateCity({CityModel updatedCity}) async {
    return await citiesCollection
        .doc(updatedCity.id.toString())
        .update(updatedCity.toJson());
  }

  //delete existing City
  Future deleteCity({CityModel deleteCity}) async {
    return await citiesCollection.doc(deleteCity.id.toString()).delete();
  }

  // stream for live City
  Stream<List<CityModel>> get getLiveCities {
    return citiesCollection.snapshots().map(CityModel().fromQuery);
  }

  /// --------------------- City --------------------- ///

  /// --------------------- SubCity --------------------- ///
  //add new SubCity
  Future addSubCity({SubCityModel newCity}) async {
    var ref = subCitiesCollection.doc();
    newCity.id = ref.id;
    return await ref.set(newCity.toJson());
  }

  //update existing SubCity
  Future updateSubCity({SubCityModel updatedCity}) async {
    return await subCitiesCollection
        .doc(updatedCity.id.toString())
        .update(updatedCity.toJson());
  }

  //delete existing SubCity
  Future deleteSubCity({SubCityModel deleteCity}) async {
    return await subCitiesCollection.doc(deleteCity.id.toString()).delete();
  }

  // stream for live SubCity
  Stream<List<SubCityModel>> getLiveSubCities(String id) {
    print('reeee $id');
    return subCitiesCollection.where('mainCityId' , isEqualTo:id ).snapshots().map(SubCityModel().fromQuery);
  }

  /// --------------------- SubCity --------------------- ///

  // --------------------- Spec --------------------- //

  //add new Spec
  Future addSpeciality({SpecialityModel newSpeciality}) async {
    var ref = specialityCollection.doc();
    newSpeciality.id = ref.id;
    return await ref.set(newSpeciality.toJson());
  }

  //update existing Spec
  Future updateSpeciality({SpecialityModel updatedSpeciality}) async {
    return await specialityCollection
        .doc(updatedSpeciality.id.toString())
        .update(updatedSpeciality.toJson());
  }

  //delete existing Spec
  Future deleteSpeciality({SpecialityModel deleteSpeciality}) async {
    return await specialityCollection.doc(deleteSpeciality.id.toString()).delete();
  }

  // stream for live Spec
  Stream<List<SpecialityModel>> get getLiveSpeciality {
    return specialityCollection.snapshots().map(SpecialityModel().fromQuery);
  }

  // --------------------- Spec --------------------- //


  /// --------------------- Doctor --------------------- ///
  //add new Doctor
  Future addDoctor({DoctorModel newDoctor}) async {
    var ref = doctorsCollection.doc();
    newDoctor.id = ref.id;
    return await ref.set(newDoctor.toJson());
  }

  //update existing Doctor
  Future updateDoctor({DoctorModel updatedDoctor}) async {
    return await doctorsCollection
        .doc(updatedDoctor.id.toString())
        .update(updatedDoctor.toJson());
  }

  //delete existing Doctor
  Future deleteDoctor({DoctorModel deleteDoctor}) async {
    return await doctorsCollection.doc(deleteDoctor.id.toString()).delete();
  }

  // stream for live Doctor
  Stream<List<DoctorModel>> get getLiveDoctor {
    return doctorsCollection.snapshots().map(DoctorModel().fromQuery);
  }

  /// --------------------- Doctor --------------------- ///


  // --------------------- Help --------------------- //
  //add new Doctor
  Future addSOS({HelpModel newSOS}) async {
    var ref = sosCollection.doc();
    newSOS.id = ref.id;
    return await ref.set(newSOS.toJson());
  }

  //delete existing Doctor
  Future deleteSOS({HelpModel newSOS}) async {
    return await sosCollection.doc(newSOS.id.toString()).delete();
  }

  // stream for live Doctor
  Stream<List<HelpModel>> getLiveLocations(bool isNew) {
    return sosCollection.where('isSolved',isEqualTo: isNew).orderBy('time',descending: true).snapshots().map(HelpModel().fromQuery);
  }

  // --------------------- Help --------------------- //

}

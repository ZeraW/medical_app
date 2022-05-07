import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../models/db_model.dart';
import 'auth.dart';

class DatabaseService {
  // Users collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference patientCollection =
      FirebaseFirestore.instance.collection('Patients');
  final CollectionReference citiesCollection =
      FirebaseFirestore.instance.collection('Cities');
  final CollectionReference subCitiesCollection =
      FirebaseFirestore.instance.collection('SubCities');

  final CollectionReference specialityCollection =
      FirebaseFirestore.instance.collection('Speciality');

  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('Doctors');
  final CollectionReference appointmentCollection =
      FirebaseFirestore.instance.collection('Appointments');

  final CollectionReference sosCollection =
      FirebaseFirestore.instance.collection('SOS');

  final CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('Report');

  // --------------------- User --------------------- //
  //get my user
  Stream<UserModel> get getUserById {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()));
  }

  Stream<UserModel> getUser(String id) {
    return userCollection
        .doc(id)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()));
  }

  //upload Image method
  Future uploadImageToStorage({File file, String id}) async {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('images/$id.png');

    firebase_storage.UploadTask task = ref.putFile(file);

    // We can still optionally use the Future alongside the stream.
    try {
      //update image
      await task;
      String url =
          await FirebaseStorage.instance.ref('images/$id.png').getDownloadURL();

      return url;
    } on firebase_storage.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  // stream for live Patient
  Stream<List<PatientModel>> get getLivePatients {
    return patientCollection.snapshots().map(PatientModel().fromQuery);
  }

  //upload Image method
  Future uploadFileToStorage({File file, String id}) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('file/$id${extension(file.path)}');

    firebase_storage.UploadTask task = ref.putFile(file);

    // We can still optionally use the Future alongside the stream.
    try {
      //update image
      await task;
      String url = await FirebaseStorage.instance
          .ref('file/$id${extension(file.path)}')
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
  /// --------------------- Patient --------------------- ///

  //updatePatientData
  Future<void> updatePatientData({PatientModel user}) async {
    return await patientCollection.doc(user.id).set(user.toJson());
  }

  Stream<PatientModel> getPatient(String id) {
    return patientCollection
        .doc(id)
        .snapshots()
        .map((event) => PatientModel.fromJson(event.data()));
  }

  Stream<List<DiagnosisModel>> getLiveDiagnosis(String id) {
    return patientCollection
        .doc(id)
        .collection('Diagnosis')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(DiagnosisModel().fromQuery);
  }

  Stream<List<HistoryFilesModel>> getLiveHistoryFiles(String id) {
    return patientCollection
        .doc(id)
        .collection('Files')
        .orderBy('date', descending: true)
        .snapshots()
        .map(HistoryFilesModel().fromQuery);
  }

  Future addFile(
      {HistoryFilesModel add, @required File file, String id}) async {
    var ref = patientCollection.doc(id).collection('Files').doc();
    add.id = ref.id;
    add.fileUrl = await (DatabaseService()
        .uploadFileToStorage(id: 'user/$id/${ref.id}', file: file));
    return await ref.set(add.toMap());
  }

  Future deleteFile({HistoryFilesModel model, String id}) async {
    var ref = patientCollection.doc(id).collection('Files').doc(model.id);
    return await ref.delete();
  }

  Future addDiagnosis({DiagnosisModel add, String id}) async {
    var ref = patientCollection.doc(id).collection('Diagnosis').doc();
    add.id = ref.id;
    return await ref.set(add.toMap());
  }

  //update existing patient
  Future updatePatient(
      {PatientModel updated, File image, bool passChanged}) async {
    if (image != null) {
      updated.image = await (DatabaseService()
          .uploadImageToStorage(id: 'patient/${updated.id}', file: image));
    }

    if (passChanged) {
      AuthService().changePassword(updated.password, () async {
        await patientCollection
            .doc(updated.id.toString())
            .update(updated.toJson());
      });
    } else {
      await patientCollection
          .doc(updated.id.toString())
          .update(updated.toJson());
    }
  }

  /// --------------------- Patient --------------------- ///

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
  // --------------------- Appointment --------------------- ///
  //add new
  Future addAppointment({AppointmentModel add}) async {
    var ref = appointmentCollection.doc();
    add.id = ref.id;
    return await ref.set(add.toJson());
  }

  //update existing
  Future updateAppointment({AppointmentModel update}) async {
    return await appointmentCollection
        .doc(update.id.toString())
        .update(update.toJson());
  }

  //delete existing
  Future deleteAppointment({AppointmentModel delete}) async {
    return await appointmentCollection.doc(delete.id.toString()).delete();
  }

  Stream<List<AppointmentModel>> getLiveAppointmentPatient(bool isNew) {
    if (isNew) {
      return appointmentCollection
          .where(
            'keyWords.patientId',
            isEqualTo: FirebaseAuth.instance.currentUser.uid,
          )
          .where('keyWords.status', isEqualTo: 0)
          .snapshots()
          .map(AppointmentModel().fromQuery);
    } else {
      return appointmentCollection
          .where('keyWords.patientId',
              isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .where('keyWords.status', isGreaterThan: 0)
          .snapshots()
          .map(AppointmentModel().fromQuery);
    }
  }

  Stream<List<AppointmentModel>> getLiveAppointmentDoctor(bool isNew) {
    if (isNew) {
      return appointmentCollection
          .where(
            'keyWords.doctorId',
            isEqualTo: FirebaseAuth.instance.currentUser.uid,
          )
          .where('keyWords.status', isEqualTo: 0)
          .orderBy('keyWords.time')
          .snapshots()
          .map(AppointmentModel().fromQuery);
    } else {
      return appointmentCollection
          .where(
            'keyWords.doctorId',
            isEqualTo: FirebaseAuth.instance.currentUser.uid,
          )
          .where('keyWords.status', isGreaterThan: 0)
          .snapshots()
          .map(AppointmentModel().fromQuery);
    }
  }

  Stream<List<AppointmentModel>> getLiveAppointmentAdmin(bool isNew) {
    if (isNew) {
      return appointmentCollection
          .where('keyWords.status', isEqualTo: 0)
          .orderBy('keyWords.time')
          .snapshots()
          .map(AppointmentModel().fromQuery);
    } else {
      return appointmentCollection
          .where('keyWords.status', isGreaterThan: 0)
          .snapshots()
          .map(AppointmentModel().fromQuery);
    }
  }


  // --------------------- Appointment --------------------- ///

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
    return subCitiesCollection
        .where('mainCityId', isEqualTo: id)
        .snapshots()
        .map(SubCityModel().fromQuery);
  }

  // stream for live City
  Stream<List<SubCityModel>> get getLiveSubCity {
    return subCitiesCollection.snapshots().map(SubCityModel().fromQuery);
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
    return await specialityCollection
        .doc(deleteSpeciality.id.toString())
        .delete();
  }

  // stream for live Spec
  Stream<List<SpecialityModel>> get getLiveSpeciality {
    return specialityCollection.snapshots().map(SpecialityModel().fromQuery);
  }

  // --------------------- Spec --------------------- //

  /// --------------------- Doctor --------------------- ///
  //add new Doctor
  Future addDoctor({DoctorModel newDoctor}) async {
    var ref = doctorsCollection.doc(newDoctor.id);
    return await ref.set(newDoctor.toJson());
  }

  //add Patient to  Doctor list
  Future addPatient2DoctorList({String docId, PatientModel newPatient}) async {
    var ref = doctorsCollection.doc(docId);
    return ref.update({
      'patients.${newPatient.id}': 'true',
    });
  }

  //update existing Doctor
  Future updateDoctor(
      {DoctorModel updatedDoctor, File image, bool passChanged}) async {
    if (image != null) {
      updatedDoctor.image = await (DatabaseService()
          .uploadImageToStorage(id: 'doctor/${updatedDoctor.id}', file: image));
    }

    if (passChanged) {
      AuthService().changePassword(updatedDoctor.password, () async {
        await doctorsCollection
            .doc(updatedDoctor.id.toString())
            .update(updatedDoctor.toJson());
      });
    } else {
      await doctorsCollection
          .doc(updatedDoctor.id.toString())
          .update(updatedDoctor.toJson());
    }
  }

  //delete existing Doctor
  Future deleteDoctor({DoctorModel deleteDoctor}) async {
    return await doctorsCollection.doc(deleteDoctor.id.toString()).delete();
  }

  // stream for live Doctor
  Stream<List<DoctorModel>> get getLiveDoctor {
    return doctorsCollection.snapshots().map(DoctorModel().fromQuery);
  }

  Stream<DoctorModel> getDoc(String id) {
    return doctorsCollection
        .doc(id)
        .snapshots()
        .map((event) => DoctorModel.fromJson(event.data()));
  }

  Stream<List<DoctorModel>> queryDoctors(Query ref) {
    return ref.snapshots().map(DoctorModel().fromQuery);
  }

  /// --------------------- Doctor --------------------- ///

  // --------------------- Help --------------------- //
  Future addSOS({HelpModel newSOS}) async {
    var ref = sosCollection.doc();
    newSOS.id = ref.id;
    return await ref.set(newSOS.toJson());
  }

  Future updateSOS({HelpModel sos}) async {
    return await sosCollection.doc(sos.id).update(sos.toJson());
  }

  Future deleteSOS({HelpModel newSOS}) async {
    return await sosCollection.doc(newSOS.id.toString()).delete();
  }

  Stream<List<HelpModel>> getLiveLocations(bool isNew) {
    return sosCollection
        .where('isSolved', isEqualTo: isNew)
        .orderBy('time', descending: true)
        .snapshots()
        .map(HelpModel().fromQuery);
  }

  // --------------------- Help --------------------- //

  /// --------------------- patientTest --------------------- //
  Future addTest({PatientTestModel newTest}) async {
    var ref = userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('test')
        .doc();
    newTest.id = ref.id;
    return await ref.set(newTest.toMap());
  }

  Future updateTest({PatientTestModel test}) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('test')
        .doc(test.id)
        .update(test.toMap());
  }

  Future deleteTest({PatientTestModel newTest}) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('test')
        .doc(newTest.id.toString())
        .delete();
  }

  Stream<List<PatientTestModel>> getLiveTests(bool isNew) {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('test')
        .where('isSolved', isEqualTo: isNew)
        .orderBy('time', descending: true)
        .snapshots()
        .map(PatientTestModel().fromQuery);
  }

  /// --------------------- patientTest --------------------- //

  // --------------------- Report --------------------- //

  Future updateReport({int price, String docId}) async {
    DateTime dateTime = DateTime.now();
    String currentMonth = ('${dateTime.year}-${dateTime.month}');
    print(currentMonth.toString());

    var ref = reportCollection.doc('${dateTime.year}');
    ref.get().then((value) {
      if (value.exists) {
        return ref.update({
          'report.profits in:$currentMonth': FieldValue.increment(price),
          'report.visitation count in:$currentMonth': FieldValue.increment(1),
          'report.priceTotal': FieldValue.increment(price),
          'report.countTotal': FieldValue.increment(1),
          'doctorProfit.$docId': FieldValue.increment(price),
          '$docId profit in:$currentMonth': FieldValue.increment(price),
          'doctorVisitation.$docId': FieldValue.increment(1),
          '$docId visitation in:$currentMonth': FieldValue.increment(1),
        });
      } else {
        ReportModel newReport = ReportModel(
          id: '${dateTime.year}',
          report: {
            'profits in:$currentMonth': price,
            'visitation count in:$currentMonth': 1,
            'priceTotal': price,
            'countTotal': 1,
          },
          doctorProfit: {
            '$docId': price,
            '$docId profit in:$currentMonth': price,
          },
          doctorVisitation: {
            '$docId': 1,
            '$docId visitation in:$currentMonth': 1,
          },
        );
        return ref.set(newReport.toMap());
      }
    });
  }

  // stream reports
  Stream<ReportModel> getLiveReport(String resId) {
    return reportCollection
        .doc(resId)
        .snapshots()
        .map((event) => ReportModel.fromMap(event.data()));
  }

// --------------------- Report --------------------- //

}

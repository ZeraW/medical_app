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

/////////////////////////////////// User ///////////////////////////////////
  //get my user


  Stream<UserModel> get getUserById {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()));
  }

  Stream<List<UserModel>> getLiveUsers(int depart, int level) {
    return userCollection
        .where('keyWords.department', isEqualTo: depart)
        .where('keyWords.level', isEqualTo: level)
        .snapshots()
        .map(UserModel().fromQuery);
  }

/*  //upload Image method
  Future uploadImageToStorage({File file, String userId}) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('images/users/$userId.png');

    firebase_storage.UploadTask task = ref.putFile(file);

task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });


    // We can still optionally use the Future alongside the stream.
    try {
      //update image
      await task;
      String url = await FirebaseStorage.instance
          .ref('images/users/${userId}.png')
          .getDownloadURL();

      return url;
    } on firebase_storage.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }*/


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
          .ref('images/${id}.png')
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
  
/////////////////////////////////// User ///////////////////////////////////


}

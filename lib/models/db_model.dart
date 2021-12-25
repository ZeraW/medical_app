import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, password, name, userId, type;

  int level, department;
  final Map<String, int> keyWords;

  UserModel(
      {this.id,
      this.password,
      this.name,
      this.userId,
      this.type,
      this.level,
      this.department,
      this.keyWords});

  UserModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.get('id'),
        password = doc.get('password'),
        name = doc.get('name'),
        userId = doc.get('userId'),
        level = doc.get('level'),
        keyWords = doc.get('keyWords') != null
            ? Map<String, int>.from(doc.get('keyWords'))
            : {},
        department = doc.get('department'),
        type = doc.get('type');

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        name = json['name'],
        userId = json['userId'],
        level = json['level'],
        keyWords = json['keyWords'] != null
            ? Map<String, int>.from(json['keyWords'])
            : {},
        department = json['department'],
        type = json['type'];

  List<UserModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          id: doc.get('id'),
          password: doc.get('password'),
          name: doc.get('name'),
          userId: doc.get('userId'),
          level: doc.get('level'),
          keyWords: doc.get('keyWords') != null
              ? Map<String, int>.from(doc.get('keyWords'))
              : {},
          department: doc.get('department'),
          type: doc.get('type'));
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'userId': userId,
      'level': level,
      'keyWords': {'level': level, 'department': department},
      'department': department,
      'type': type,
    };
  }
}

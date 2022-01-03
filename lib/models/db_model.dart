import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, password, name, userId, type;
  UserModel(
      {this.id,
      this.password,
      this.name,
      this.userId,
      this.type});

  UserModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.get('id'),
        password = doc.get('password'),
        name = doc.get('name'),
        userId = doc.get('userId'),
        type = doc.get('type');

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        name = json['name'],
        userId = json['userId'],
        type = json['type'];

  List<UserModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          id: doc.get('id'),
          password: doc.get('password'),
          name: doc.get('name'),
          userId: doc.get('userId'),
          type: doc.get('type'));
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'userId': userId,
      'type': type,
    };
  }
}
class CityModel {
   String id;
  final String name;

  CityModel({this.id, this.name});

  List<CityModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CityModel(
        id: doc.get('id')  ?? '',
        name: doc.get('name')?? '',
      );
    }).toList();
  }

  CityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
class SpecialityModel {
  String id;
  final String name;

  SpecialityModel({this.id, this.name});

  List<SpecialityModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SpecialityModel(
        id: doc.get('id')  ?? '',
        name: doc.get('name')?? '',
      );
    }).toList();
  }

  SpecialityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class DoctorModel {
  String id;
  String name;
  String image;
  String about;
  String gender;
  String city;
  String specialty;
  String rate;
  String phone;


  DoctorModel(
      {this.id,
      this.name,
      this.image,
      this.about,
      this.gender,
      this.city,
      this.specialty,
      this.rate,
      this.phone});


  List<DoctorModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DoctorModel(
        id: doc.get('id') ,
        name: doc.get('name') ,
        image: doc.get('image') ,
        about: doc.get('about') ,
        gender: doc.get('gender') ,
        city: doc.get('city') ,
        specialty: doc.get('specialty') ,
        rate: doc.get('rate') ,
        phone: doc.get('phone')
      );
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'about': this.about,
      'gender': this.gender,
      'city': this.city,
      'specialty': this.specialty,
      'rate': this.rate,
      'phone': this.phone,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      about: map['about'] as String,
      gender: map['gender'] as String,
      city: map['city'] as String,
      specialty: map['specialty'] as String,
      rate: map['rate'] as String,
      phone: map['phone'] as String,
    );
  }

}

class HelpModel {
  String id;
  UserModel user;
  String lat, lon;
  DateTime time;
  bool isSolved;
  HelpModel({
    this.id,
    this.user,
    this.lat,
    this.lon,
    this.time,
    this.isSolved
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'user': this.user.toJson(),
      'lat': this.lat,
      'lon': this.lon,
      'time': this.time,
      'isSolved': this.isSolved,

    };
  }


  List<HelpModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HelpModel(
        id: doc.get('id') as String,
        user: UserModel.fromJson(doc.get('user')),
        lat: doc.get('lat') as String,
        lon: doc.get('lon') as String,
        time: doc.get('time').toDate(),
        isSolved: doc.get('isSolved'),

      );
    }).toList();
  }

  factory HelpModel.fromJson(Map<String, dynamic> map) {
    return HelpModel(
      id: map['id'] as String,
      user: map['user'] as UserModel,
      lat: map['lat'] as String,
      lon: map['lon'] as String,
      time: map['time'] as DateTime,
      isSolved: map['isSolved'] as bool,

    );
  }
}
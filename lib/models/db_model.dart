import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, password, name, userId, type;

  UserModel({this.id, this.password, this.name, this.userId, this.type});

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
        id: doc.get('id') ?? '',
        name: doc.get('name') ?? '',
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

class SubCityModel {
  String id, mainCityId;
  final String name;

  SubCityModel({this.id, this.mainCityId, this.name});

  List<SubCityModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SubCityModel(
        id: doc.get('id') ?? '',
        mainCityId: doc.get('mainCityId') ?? '',
        name: doc.get('name') ?? '',
      );
    }).toList();
  }

  SubCityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        mainCityId = json['mainCityId'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mainCityId'] = this.mainCityId;

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
        id: doc.get('id') ?? '',
        name: doc.get('name') ?? '',
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
  String subCity;
  String password;
  String specialty;
  String rate;
  String phone;
  String address;
  Map<String, String> keyWords;

  Map<String, dynamic> appointments;

  DoctorModel(
      {this.id,
      this.name,
      this.image,
      this.about,
      this.gender,
      this.city,
      this.subCity,
      this.specialty,
      this.password,
      this.rate,
      this.keyWords,
      this.appointments,
      this.address,
      this.phone});

  List<DoctorModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DoctorModel(
          id: doc.get('id'),
          name: doc.get('name'),
          image: doc.get('image'),
          about: doc.get('about'),
          gender: doc.get('gender'),
          city: doc.get('city'),
          password: doc.get('password'),
          specialty: doc.get('specialty'),
          rate: doc.get('rate'),
          keyWords: doc.get('keyWords') != null
              ? Map<String, String>.from(doc.get('keyWords'))
              : {},
          appointments: doc.get(
              'appointments') /*!= null
              ? Map<String, Timestamp>.from(doc.get('appointments')).map<String ,DateTime>(
                (key, value) {
              return MapEntry(key.toString(), value.toDate());
            }
          )
              : {}*/
          ,
          phone: doc.get('phone'),
          address: doc.get('address'),
          subCity: doc.get('subCity'));
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'about': this.about,
      'gender': this.gender,
      'password': this.password,
      'city': this.city,
      'specialty': this.specialty,
      'rate': this.rate,
      'keyWords': this.keyWords,
      'appointments': this.appointments,
      'phone': this.phone,
      'address': this.address,
      'subCity': this.subCity,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      about: map['about'] as String,
      gender: map['gender'] as String,
      password: map['password'] as String,
      city: map['city'] as String,
      keyWords: map['keyWords'] != null
          ? Map<String, String>.from(map['keyWords'])
          : {},
      appointments: map['appointments'] != null
          ? Map<String, dynamic>.from(map['appointments'])
              .map<String, DateTime>((key, value) {
              return MapEntry(key.toString(), value.toDate());
            })
          : {},
      specialty: map['specialty'] as String,
      rate: map['rate'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      subCity: map['subCity'] as String,
    );
  }
}

class HelpModel {
  String id;
  UserModel user;
  String lat, lon;
  DateTime time;
  bool isSolved;

  HelpModel({this.id, this.user, this.lat, this.lon, this.time, this.isSolved});

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

class DiagnosisModel {
  String patientName, doctorName, spec, date, complain, diagnosis, treatment;
  DateTime timestamp;

  DiagnosisModel({
    this.patientName,
    this.doctorName,
    this.spec,
    this.date,
    this.timestamp,
    this.complain,
    this.diagnosis,
    this.treatment,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientName': this.patientName,
      'doctorName': this.doctorName,
      'spec': this.spec,
      'date': this.date,
      'timestamp': this.timestamp,

      'complain': this.complain,
      'diagnosis': this.diagnosis,
      'treatment': this.treatment,
    };
  }

  List<DiagnosisModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DiagnosisModel(
        patientName: doc.get('patientName'),
        doctorName: doc.get('doctorName'),
        spec: doc.get('spec'),
        timestamp: doc.get('timestamp').toDate(),

        date: doc.get('date'),
        complain: doc.get('complain'),
        diagnosis: doc.get('diagnosis'),
        treatment: doc.get('treatment'),
      );
    }).toList();
  }

  factory DiagnosisModel.fromMap(Map<String, dynamic> map) {
    return DiagnosisModel(
      patientName: map['patientName'] as String,
      doctorName: map['doctorName'] as String,
      timestamp: map['timestamp'] as DateTime,

      spec: map['spec'] as String,
      date: map['date'] as String,
      complain: map['complain'] as String,
      diagnosis: map['diagnosis'] as String,
      treatment: map['treatment'] as String,
    );
  }
}

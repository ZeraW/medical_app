import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, password, name, email, phone, type;

  UserModel(
      {this.id, this.password, this.email, this.name, this.phone, this.type});

  UserModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.get('id'),
        password = doc.get('password'),
        name = doc.get('name'),
        email = doc.get('email'),
        phone = doc.get('phone'),
        type = doc.get('type');

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        type = json['type'];

  List<UserModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
          id: doc.get('id'),
          password: doc.get('password'),
          name: doc.get('name'),
          email: doc.get('email'),
          phone: doc.get('phone'),
          type: doc.get('type'));
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
    };
  }
}

class PatientModel {
  String id, password, name, phone, email, gender, image, age;

  PatientModel(
      {this.id,
      this.password,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.age,
      this.image});

  PatientModel.fromSnapShot(DocumentSnapshot doc)
      : id = doc.get('id'),
        password = doc.get('password'),
        name = doc.get('name'),
        email = doc.get('email'),
        gender = doc.get('gender'),
        age = doc.get('age'),
        image = doc.get('image'),
        phone = doc.get('phone');

  PatientModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'],
        name = json['name'],
        email = json['email'],
        gender = json['gender'],
        image = json['image'],
        age = json['age'],
        phone = json['phone'];

  List<PatientModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PatientModel(
          id: doc.get('id'),
          password: doc.get('password'),
          name: doc.get('name'),
          email: doc.get('email'),
          gender: doc.get('gender'),
          image: doc.get('image'),
          age: doc.get('age'),
          phone: doc.get('phone'));
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'gender': gender,
      'email': email,
      'image': image,
      'age': age,
      'phone': phone,
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
  String id,
      name,
      image,
      about,email,
      gender,
      city,
      subCity,
      password,
      specialty,
      fees,
      rate,
      phone,
      address;
  Map<String, String> keyWords;

  Map<String, DateTime> appointments;

  DoctorModel(
      {this.id,
      this.name,
      this.image,
      this.about,this.email,
      this.gender,
      this.city,
      this.subCity,
      this.specialty,
      this.password,
      this.fees,
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
          email: doc.get('email'),

          image: doc.get('image'),
          about: doc.get('about'),
          gender: doc.get('gender'),
          city: doc.get('city'),
          fees: doc.get('fees'),
          password: doc.get('password'),
          specialty: doc.get('specialty'),
          rate: doc.get('rate'),
          keyWords: doc.get('keyWords') != null
              ? Map<String, String>.from(doc.get('keyWords'))
              : {},
          appointments: doc.get('appointments') != null
              ? Map<String, Timestamp>.from(doc.get('appointments'))
                  .map<String, DateTime>((key, value) {
                  return MapEntry(key.toString(), value.toDate());
                })
              : {},
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
      'email': this.email,

      'about': this.about,
      'gender': this.gender,
      'password': this.password,
      'fees': this.fees,
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
      email: map['email'] as String,

      image: map['image'] as String,
      about: map['about'] as String,
      gender: map['gender'] as String,
      fees: map['fees'] as String,
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
  PatientModel user;
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
        user: PatientModel.fromJson(doc.get('user')),
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
      user: map['user'] as PatientModel,
      lat: map['lat'] as String,
      lon: map['lon'] as String,
      time: map['time'] as DateTime,
      isSolved: map['isSolved'] as bool,
    );
  }
}

class AppointmentModel {
  String id;
  String patientId;
  String patientName;

  String doctorId;
  DateTime time;
  int status;
  Map<String, dynamic> keyWords;

  AppointmentModel(
      {this.id,
      this.patientId,
      this.doctorId,
      this.patientName,
      this.time,
      this.status,
      this.keyWords});

  List<AppointmentModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppointmentModel(
          id: doc.get('id') as String,
          patientName: doc.get('patientName') as String,
          patientId: doc.get('patientId') as String,
          doctorId: doc.get('doctorId') as String,
          status: doc.get('status'),
          time: doc.get('time').toDate(),
          keyWords: doc.get('keyWords') != null
              ? Map<String, dynamic>.from(doc.get('keyWords'))
              : {});
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'patientId': this.patientId,
      'doctorId': this.doctorId,
      'patientName': this.patientName,
      'time': this.time,
      'status': this.status,
      'keyWords': this.keyWords,
    };
  }

  AppointmentModel copyWith({
    String id,
    String patientId,
    String patientName,
    String doctorId,
    DateTime time,
    int status,
    Map<String, dynamic> keyWords,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      time: time ?? this.time,
      status: status ?? this.status,
      keyWords: keyWords ?? this.keyWords,
    );
  }
}

class DiagnosisModel {
  String id, patientName, doctorName, spec, complain, diagnosis, treatment;
  DateTime timestamp;

  DiagnosisModel({
    this.patientName,
    this.id,
    this.doctorName,
    this.spec,
    this.timestamp,
    this.complain,
    this.diagnosis,
    this.treatment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'patientName': this.patientName,
      'doctorName': this.doctorName,
      'spec': this.spec,
      'timestamp': this.timestamp,
      'complain': this.complain,
      'diagnosis': this.diagnosis,
      'treatment': this.treatment,
    };
  }

  List<DiagnosisModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DiagnosisModel(
        id: doc.get('id'),
        patientName: doc.get('patientName'),
        doctorName: doc.get('doctorName'),
        spec: doc.get('spec'),
        timestamp: doc.get('timestamp').toDate(),
        complain: doc.get('complain'),
        diagnosis: doc.get('diagnosis'),
        treatment: doc.get('treatment'),
      );
    }).toList();
  }
}

class HistoryFilesModel {
  String id, title, details, fileUrl;
  DateTime date;

  HistoryFilesModel(
      {this.date, this.id, this.fileUrl, this.title, this.details});

  List<HistoryFilesModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HistoryFilesModel(
        id: doc.get('id'),
        title: doc.get('title'),
        fileUrl: doc.get('fileUrl'),
        details: doc.get('details'),
        date: doc.get('date').toDate(),
      );
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'details': this.details,
      'fileUrl': this.fileUrl,
      'date': this.date,
    };
  }
}

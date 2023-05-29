import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  // Properties
  String uid;
  String name;
  String email;
  String password;
  String? token;
  DateTime? dateJoined;
  String? bio;
  String? gender;
  int? age;
  String? location;
  bool? isAdoptee;

  // Constructor
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
    required this.dateJoined,
    required this.bio,
    required this.gender,
    required this.age,
    required this.location,
    this.isAdoptee = false,
  });

  //Constructor only for registration
  AppUser.register({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
    required this.dateJoined,
  });

  //constructor only for login
  AppUser.login({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  // empty constructor
  AppUser.empty()
      : uid = '',
        name = '',
        email = '',
        password = '',
        token = '',
        dateJoined = DateTime.now(),
        isAdoptee = false,
        gender = '',
        age = 0,
        location = '',
        bio = '';

  // Constructor with only uid
  AppUser.withId(this.uid)
      : name = '',
        email = '',
        password = '',
        token = '',
        dateJoined = DateTime.now(),
        gender = '',
        age = 0,
        location = '',
        bio = '',
        isAdoptee = false;

  // Methods
  // Convert JSON to User object
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      dateJoined: json['dateJoined'].toDate(),
      bio: json['bio'],
      gender: json['gender'],
      age: json['age'],
      location: json['location'],
      isAdoptee: json['isAdoptee'],
    );
  }

  factory AppUser.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('No data in snapshot');

    return AppUser(
      uid: snapshot['uid'],
      name: snapshot['name'],
      email: snapshot['email'],
      password: snapshot['password'],
      token: snapshot['token'],
      dateJoined: snapshot['dateJoined'].toDate(),
      bio: snapshot['bio'],
      gender: snapshot['gender'],
      age: snapshot['age'],
      location: snapshot['location'],
      isAdoptee: snapshot['isAdoptee'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'token': token,
        'dateJoined': dateJoined!.toIso8601String,
        'bio': bio,
        'gender': gender,
        'age': age,
        'location': location,
        'isAdoptee': isAdoptee,
      };

  // Convert User object to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'token': token,
      'dateJoined': dateJoined,
      'bio': bio,
      'gender': gender,
      'age': age,
      'location': location,
      'isAdoptee': isAdoptee,
    };
  }

  // Convert Map to User object
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      token: map['token'],
      dateJoined: map['dateJoined'].toDate(),
      bio: map['bio'],
      gender: map['gender'],
      age: map['age'],
      location: map['location'],
      isAdoptee: map['isAdoptee'],
    );
  }
}

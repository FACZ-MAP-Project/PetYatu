// User data model
// Class
class AppUser {
  // Properties
  String uid;
  String name;
  String email;
  String password;
  String token;
  bool isAdoptee;

  // Constructor
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
    this.isAdoptee = false,
  });

  // empty constructor
  AppUser.empty()
      : uid = '',
        name = '',
        email = '',
        password = '',
        token = '',
        isAdoptee = false;

  // Constructor with only uid
  AppUser.withId(this.uid)
      : name = '',
        email = '',
        password = '',
        token = '',
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
      isAdoptee: json['isAdoptee'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'token': token,
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
    );
  }
}

// // Methods
//   // Convert JSON to User object
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       password: json['password'],
//       token: json['token'],
//     );
//   }

//   // Convert User object to JSON
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'email': email,
//         'password': password,
//         'token': token,
//       };
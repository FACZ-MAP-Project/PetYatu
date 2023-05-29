// import dart convert
import 'dart:convert';

// Pet data model
class Pet {
  String uid;
  String name;
  int? age;
  String? type;
  String? image;
  List<String>? gallery;
  String? owner;
  String? contact;
  String? location;
  DateTime? datePosted;
  String? bio;
  bool? isOpenForAdoption;

  Pet({
    required this.uid,
    required this.name,
    required this.type,
    required this.image,
    required this.age,
    required this.gallery,
    required this.owner,
    required this.contact,
    required this.location,
    required this.datePosted,
    required this.bio,
    required this.isOpenForAdoption,
  });

  // empty constructor
  Pet.empty()
      : uid = '',
        name = '',
        type = '',
        image = '',
        age = 0,
        gallery = [],
        owner = '',
        contact = '',
        location = '',
        datePosted = null,
        bio = '',
        isOpenForAdoption = false;

  factory Pet.fromJson(Map<String, dynamic> json) {
    List<dynamic> galleryJson = json['gallery'];
    List<String>? gallery = galleryJson != null
        ? galleryJson.map((item) => item.toString()).toList()
        : null;

    return Pet(
      uid: json['uid'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      age: json['age'],
      gallery: gallery,
      owner: json['owner'],
      contact: json['contact'],
      location: json['location'],
      datePosted: json['datePosted'].toDate(),
      bio: json['bio'],
      isOpenForAdoption: json['isOpenForAdoption'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'type': type,
        'image': image,
        'age': age,
        'gallery': gallery,
        'owner': owner,
        'location': location,
        'datePosted': datePosted,
        'bio': bio,
        'isOpenForAdoption': isOpenForAdoption,
      };

  @override
  String toString() {
    return 'Pet{uid: $uid, name: $name, type: $type, image: $image}';
  }
}

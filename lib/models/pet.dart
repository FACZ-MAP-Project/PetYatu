// Pet data model
class Pet {
  String uid;
  String name;
  int age;
  String? type;
  String? image;
  List<String>? gallery;
  String owner;
  String location;
  DateTime? datePosted;
  String bio;

  Pet({
    required this.uid,
    required this.name,
    required this.type,
    required this.image,
    required this.age,
    required this.gallery,
    required this.owner,
    required this.location,
    required this.datePosted,
    required this.bio,
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
        location = '',
        datePosted = null,
        bio = '';

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      uid: json['uid'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      age: json['age'],
      gallery: json['gallery'],
      owner: json['owner'],
      location: json['location'],
      datePosted: json['datePosted'].toDate(),
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'type': type,
        'image': image,
      };

  @override
  String toString() {
    return 'Pet{uid: $uid, name: $name, type: $type, image: $image}';
  }
}

// Pet data model
class Pet {
  String uid;
  String name;
  String type;
  String image;

  Pet({
    required this.uid,
    required this.name,
    required this.type,
    required this.image,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      uid: json['uid'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
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

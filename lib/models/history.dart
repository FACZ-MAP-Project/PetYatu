class History {
  String uid;
  String user;
  String pet;
  String? otherUser;
  String image;
  DateTime dateCreated;

  History({
    required this.uid,
    required this.user,
    required this.pet,
    required this.otherUser,
    required this.image,
    required this.dateCreated,
  });

  // empty constructor
  History.empty()
      : uid = '',
        user = '',
        pet = '',
        otherUser = '',
        image = '',
        dateCreated = DateTime.now();

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      uid: json['uid'],
      user: json['user'],
      pet: json['pet'],
      otherUser: json['otherUser'],
      image: json['image'],
      dateCreated: json['dateCreated'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'user': user,
        'pet': pet,
        'otherUser': otherUser,
        'image': image,
        'dateCreated': dateCreated,
      };
}

class History {
  String uid;
  String type;
  String user;
  String sentence;
  String pet;
  String? otherUser;
  String image;
  DateTime dateCreated;

  History({
    required this.uid,
    required this.type,
    required this.user,
    required this.sentence,
    required this.pet,
    required this.otherUser,
    required this.image,
    required this.dateCreated,
  });

  // empty constructor
  History.empty()
      : uid = '',
        type = '',
        user = '',
        sentence = '',
        pet = '',
        otherUser = '',
        image = '',
        dateCreated = DateTime.now();

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      uid: json['uid'],
      type: json['type'],
      user: json['user'],
      sentence: json['sentence'],
      pet: json['pet'],
      otherUser: json['otherUser'],
      image: json['image'],
      dateCreated: json['dateCreated'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'type': type,
        'user': user,
        'sentence': sentence,
        'pet': pet,
        'otherUser': otherUser,
        'image': image,
        'dateCreated': dateCreated,
      };
}

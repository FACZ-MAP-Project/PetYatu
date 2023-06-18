class Moment {
  String uid;
  String owner;
  String pet;
  String image;
  String caption;
  DateTime datePosted;
  int likes;
  List<String> likesBy;
  int comments;
  List<String> commentsBy;

  Moment({
    required this.uid,
    required this.owner,
    required this.pet,
    required this.image,
    required this.caption,
    required this.datePosted,
    required this.likes,
    required this.likesBy,
    required this.comments,
    required this.commentsBy,
  });

  // empty constructor
  Moment.empty()
      : uid = '',
        owner = '',
        pet = '',
        image = '',
        caption = '',
        datePosted = DateTime.now(),
        likes = 0,
        comments = 0,
        likesBy = [],
        commentsBy = [];

  factory Moment.fromJson(Map<String, dynamic> json) {
    List<dynamic> commentsByJson = json['commentsBy'];
    List<dynamic> likesByJson = json['likesBy'];
    // ignore: prefer_null_aware_operators, unnecessary_null_comparison
    List<String>? commentsBy = commentsByJson != null
        ? commentsByJson.map((item) => item.toString()).toList()
        : null;

    List<String>? likesBy = likesByJson != null
        ? likesByJson.map((item) => item.toString()).toList()
        : [];

    return Moment(
      uid: json['uid'],
      owner: json['owner'],
      pet: json['pet'],
      image: json['image'],
      caption: json['caption'],
      datePosted: json['datePosted'].toDate(),
      likes: json['likes'],
      likesBy: likesBy,
      comments: json['comments'],
      commentsBy: commentsBy!,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'owner': owner,
      'pet': pet,
      'image': image,
      'caption': caption,
      'datePosted': datePosted,
      'likes': likes,
      'likesBy': likesBy,
      'comments': comments,
      'commentsBy': commentsBy,
    };
  }

  @override
  String toString() {
    return 'Moment{uid: $uid, owner: $owner, image: $image, caption: $caption, datePosted: $datePosted, likes: $likes, comments: $comments, commentsBy: $commentsBy}';
  }
}

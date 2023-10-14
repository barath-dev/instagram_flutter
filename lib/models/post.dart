class Post {
  final String uid;
  final String Caption;
  final String imageUrl;
  final DateTime dateCreated;
  final int likes;
  final List<dynamic> likedBy;
  final String? postid;
  final String profilePic;
  final String username;

  const Post({
    required this.uid,
    required this.Caption,
    required this.imageUrl,
    required this.dateCreated,
    required this.likes,
    required this.likedBy,
    required this.profilePic,
    required this.username,
    required this.postid,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'Caption': Caption,
        'imageUrl': imageUrl,
        'profilePic': profilePic,
        'username': username,
        'dateCreated': dateCreated,
        'likes': likes,
        'likedBy': likedBy,
        'postid': postid ?? '',
      };
}

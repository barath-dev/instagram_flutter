import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String profilePicUrl;
  final List<dynamic> followers;
  final List<dynamic> following;
  final DateTime dateCreated;

  const User({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.profilePicUrl,
    required this.followers,
    required this.following,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'profilePicUrl': profilePicUrl,
        'followers': followers,
        'following': following,
        'dateCreated': dateCreated,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return User(
      username: data['username'],
      uid: data['uid'],
      email: data['email'],
      bio: data['bio'],
      profilePicUrl: data['profilePicUrl'],
      followers: data['followers'],
      following: data['following'],
      dateCreated: data['dateCreated'].toDate(),
    );
  }
}

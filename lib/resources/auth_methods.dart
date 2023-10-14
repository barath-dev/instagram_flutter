// ignore_for_file: unnecessary_null_comparison, non_constant_fier_names, avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/post.dart' as modelPost;
import 'package:uuid/uuid.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User user = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return model.User.fromSnap(documentSnapshot);
  }

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? profilePic,
  }) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        //create user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String url = await StorageMethods()
            .uploadImagetoStorage("profile_pics", profilePic!, false);

        //add user to user database

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          profilePicUrl: "$url",
          dateCreated: DateTime.now(),
        );

        print(cred.user!.uid);
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //sign in
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter email and password";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        return 'No user found for the given email.';
      } else if (err.code == 'wrong-password') {
        return 'Incorrect password.';
      } else if (err.code == 'weak-password') {
        return 'Password should be at least 6 characters';
      } else if (err.code == 'invalid-email') {
        return 'Invalid email';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //sign out
  Future<String> signOutUser() async {
    String res = "Something went wrong";
    try {
      await _auth.signOut();
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> UploadPostImage({required Uint8List? image}) async {
    try {
      String url =
          await StorageMethods().uploadImagetoStorage('posts', image!, true);
      return url;
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> UploadPost({
    required String caption,
    required Uint8List? image,
    required String username,
    required String profilePic,
    required String uid,
  }) async {
    print("Uploading post");
    User? user = _auth.currentUser;

    print("Uploading image");
    String url = await UploadPostImage(image: image);
    if (url != null) {
      print("Image uploaded");
      try {
        modelPost.Post post = modelPost.Post(
          postid: Uuid().v1(),
          uid: user!.uid,
          Caption: caption,
          imageUrl: url,
          dateCreated: DateTime.now(),
          likes: 0,
          profilePic: profilePic,
          username: username,
          likedBy: [],
        );
        await _firestore
            .collection('posts')
            .doc(post.postid)
            .set(post.toJson());
        print("Uploaded post");
        return "Success";
      } catch (err) {
        return err.toString();
      }
    } else {
      return "Error";
    }
  }

  // get user details from data base and map to the User data model
  Future<model.User> getUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    print(documentSnapshot.data());
    return model.User.fromSnap(documentSnapshot);
  }

  Future<void> likePost(String postId, String uid, List likedBy) async {
    try {
      if (likedBy.contains(uid)) {
        print('unliked');
        await _firestore.collection('posts').doc(postId).update({
          'likedBy': FieldValue.arrayRemove([uid]),
          'likes': FieldValue.increment(-1),
        });
      } else {
        print('liked');
        await _firestore.collection('posts').doc(postId).update({
          'likedBy': FieldValue.arrayUnion([uid]),
          'likes': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postComment(String postid, String text, String uid,
      String ProfilePic, String username) async {
    try {
      String commentid = Uuid().v1();
      if (text.isNotEmpty) {
        _firestore
            .collection('posts')
            .doc('${postid}')
            .collection('comments')
            .doc('${commentid}')
            .set({
          'commentid': commentid,
          'text': text,
          'uid': uid,
          'username': username,
          'profilePic': ProfilePic,
          'dateCreated': DateTime.now(),
        });
        print('Comment posted');
      } else {
        print('Comment is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //delete post from database
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      print('Post deleted');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String Uid) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUserId).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(Uid)) {
        print('unfollowed');
        await _firestore.collection('users').doc(Uid).update({
          'followers': FieldValue.arrayRemove([currentUserId]),
        });
        await _firestore.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayRemove([Uid]),
        });
      } else {
        await _firestore.collection('users').doc(Uid).update({
          'followers': FieldValue.arrayUnion([currentUserId]),
        });
        await _firestore.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayUnion([Uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

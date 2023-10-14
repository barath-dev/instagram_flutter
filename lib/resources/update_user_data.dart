// ignore_for_file: prefer_is_empty, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';

class UserDetails {
  //get user data from firestore and map to user object and update the user details
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<String> CheckUserNameUpdated({
    required String email,
  }) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty) {
        //create user
        QuerySnapshot querySnapshot =
            await users.where('email', isEqualTo: email).get();
        Map map = querySnapshot.docs[0].data() as Map<String, dynamic>;
        map.forEach((key, value) {
          if (key == "username") {
            if (value == "") {
              res = "Success";
            } else {
              res = "Username already exists";
            }
          }
        });
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> CheckUserNameExists({
    required String username,
  }) async {
    String res = "Something went wrong";
    try {
      if (username.isNotEmpty) {
        //create user
        QuerySnapshot querySnapshot =
            await users.where('username', isEqualTo: username).get();
        if (querySnapshot.docs.length > 0) {
          res = "Username already exists";
        } else {
          res = "Success";
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateUser(
      {required String username, required String Bio}) async {
    if (username.isNotEmpty && Bio.isNotEmpty) {
      if (CheckUserNameExists(username: username) == "Success") {
        users
            .doc('ABC123')
            .update({'username': '$username', 'bio': '$Bio'}).then((value) {
          return "Success";
        }).catchError((error) {
          return "Something went wrong";
        });
        return "Success";
      } else {
        return "Username already exists";
      }
    } else {
      return "Username and Bio cannot be empty";
    }
  }
}

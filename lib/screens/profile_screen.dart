// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postData = {};
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var posts = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userData = snapshot.data() as Map<String, dynamic>;
      postCount = posts.docs.length;
      setState(() {
        userData = userData;
        postCount = postCount;
        followerCount = userData['followers'].length;
        followingCount = userData['following'].length;
      });
      if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          isCurrentUser = true;
        });
      } else {
        if (userData['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid)) {
          setState(() {
            isFollowing = true;
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("@${userData['username']}"),
              centerTitle: false,
              backgroundColor: Color.fromARGB(255, 31, 31, 31),
              actions: [
                isCurrentUser
                    ? IconButton(
                        icon: Icon(Icons.logout_outlined),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                      )
                    : Container(),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage("${userData['profilePicUrl']}"),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postCount, 'posts'),
                                      buildStatColumn(
                                          followerCount, 'followers'),
                                      buildStatColumn(
                                          followingCount, 'following')
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundColor: Colors.black,
                                            borderColor: Colors.white,
                                            text: "Sign Out",
                                            textcolor: Colors.white,
                                            function: () {
                                              FirebaseAuth.instance.signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return LoginScreen();
                                                  },
                                                ),
                                              );
                                            })
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                text: "Unfollow",
                                                textcolor: Colors.white,
                                                function: () async {
                                                  await AuthMethods()
                                                      .followUser(
                                                          "${widget.uid}");
                                                  setState(() {
                                                    isFollowing = false;
                                                    followerCount--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                text: "Follow",
                                                textcolor: Colors.white,
                                                function: () async {
                                                  await AuthMethods()
                                                      .followUser(
                                                          "${widget.uid}");
                                                  setState(() {
                                                    isFollowing = true;
                                                    followerCount++;
                                                  });
                                                },
                                              ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "${userData['username']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "${userData['bio']}",
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1),
                        itemBuilder: ((context, index) {
                          DocumentSnapshot post = snapshot.data!.docs[index];

                          return Container(
                              child: Image(
                            image: NetworkImage('${post['imageUrl']}'),
                            fit: BoxFit.cover,
                          ));
                        }));
                  },
                )
              ],
            ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

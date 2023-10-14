// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
          centerTitle: true,
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage('${user.profilePicUrl}'),
                ),
                Expanded(
                  child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "comment as ${user.username}...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 16),
                      )),
                ),
                InkWell(
                    onTap: () async {
                      await AuthMethods().postComment(
                        widget.snap['postid'],
                        _commentController.text,
                        user.uid,
                        user.profilePicUrl,
                        user.username,
                      );
                      setState(() {
                        _commentController.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 2, left: 2),
                      child: Text(
                        'Post',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postid'])
                .collection('comments')
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                ));
              } else {
                print(snapshot.data!.docs.length);
                return ListView.builder(
                  itemBuilder: (context, index) => CommentCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              }
            }));
  }
}

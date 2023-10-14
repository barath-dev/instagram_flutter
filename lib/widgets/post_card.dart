// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../screens/comment_screen.dart';
import '../utils/colors.dart';

class PostCard extends StatefulWidget {
  final snap;

  PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentCount = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postid'])
        .collection('comments')
        .get();
    setState(() {
      commentCount = snap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User userprovider = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profilePic']),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ProfileScreen(
                                            uid: widget.snap['uid'],
                                          ))));
                            },
                            child: Text(
                              widget.snap['username'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'] == userprovider.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  shrinkWrap: true,
                                  children: [
                                    'delete',
                                  ]
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {
                                            AuthMethods().deletePost(
                                                widget.snap['postid']);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList()),
                            ),
                          );
                        },
                        icon: Icon(Icons.more_vert))
                    : SizedBox.shrink(),
              ],
            ),
            //Image section
          ),
          GestureDetector(
              onDoubleTap: () async {
                await AuthMethods().likePost(
                  widget.snap['postid'],
                  userprovider.uid,
                  widget.snap['likedBy'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: Duration(
                      milliseconds: 350,
                    ),
                    onLiked: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likedBy'].contains(userprovider.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await AuthMethods().likePost(
                        widget.snap['postid'],
                        userprovider.uid,
                        widget.snap['likedBy'],
                      );
                    },
                    icon: Icon(
                        widget.snap['likedBy'].contains(userprovider.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 26,
                        color: widget.snap['likedBy'].contains(userprovider.uid)
                            ? Colors.pink
                            : Colors.white)),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => CommentScreen(
                                  snap: widget.snap,
                                ))));
                  },
                  icon: Icon(Icons.comment_outlined, size: 26)),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.send_outlined, size: 26)),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border_rounded,
                    size: 26,
                    color: Colors.white,
                  )),
            ],
          ),
          //Description
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                  child: Text(
                    '${widget.snap['likes']} likes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: '${widget.snap['username']}:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: '  ${widget.snap['Caption']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'View all $commentCount comments',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

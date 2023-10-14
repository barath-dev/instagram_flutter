// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Instagram'),
          actions: [
            IconButton(
              onPressed: () {
                print("tapped");
              },
              icon: const Icon(Icons.message_outlined),
            )
          ],
        ),
        body: Container(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData == false) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.blue,
                    ));
                  }
                  print(snapshot.data!.docs.length);
                  return ListView.builder(
                    itemBuilder: (context, index) => PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                    itemCount: snapshot.data!.docs.length,
                  );
                })));
  }
}

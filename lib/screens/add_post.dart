// ignore_for_file: unnecessary_const, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_null_comparison, unnecessary_string_interpolations, await_only_futures, use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/feed_Screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _imageFile;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create Post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await PickImage(ImageSource.camera);
                  setState(() {
                    _imageFile = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Pick from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await PickImage(ImageSource.gallery);
                  setState(() {
                    _imageFile = file;
                  });
                  toast("Image selected");
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController captionController = TextEditingController();
    final User userprovider = Provider.of<UserProvider>(context).getUser;
    bool _isLoading = false;

    @override
    void dispose() {
      captionController.dispose();
      super.dispose();
    }

    void clearImage() {
      setState(() {
        _imageFile = null;
      });
    }

    Future<String> fetchString() async {
      await Future.delayed(Duration(seconds: 3));
      return AuthMethods().UploadPost(
          caption: captionController.text,
          image: _imageFile,
          username: userprovider.username,
          uid: userprovider.uid,
          profilePic: userprovider.profilePicUrl);
    }

    postImage() async {
      setState(() {
        _isLoading = true;
        showSnackBar(context, 'Uploading post...');
      });
      String res = await fetchString();
      print(res);
      if (res.toString() == 'Success') {
        showSnackBar(context, 'Post uploaded successfully');
        setState(() {
          _isLoading = false;
        });
      } else {
        showSnackBar(context, 'Failed to upload post');
        setState(() {
          _isLoading = false;
        });
      }
    }

    return _imageFile == null
        ? Center(
            child: IconButton(
            icon: Icon(
              Icons.upload,
            ),
            onPressed: () => _selectImage(context),
          ))
        : Scaffold(
            appBar: AppBar(
              title: const Text('Add Post'),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    clearImage();
                    // navigate to home screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedScreen()));
                  }),
              actions: [
                TextButton(
                    onPressed: () async {
                      await postImage();
                    },
                    child: const Text('Post',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)))
              ],
            ),
            body: Column(
              children: [
                _isLoading ? showSnackBar(context, "Loading...") : Container(),
                // : const Padding(
                //     padding: EdgeInsets.only(top: 0),
                //   ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('${userprovider.profilePicUrl}'),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: captionController,
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          hintStyle: TextStyle(fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        maxLines: 8,
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 57,
                      child: AspectRatio(
                        aspectRatio: 19 / 16,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_imageFile!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ));
  }
}

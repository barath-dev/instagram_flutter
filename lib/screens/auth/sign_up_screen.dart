// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_build_context_synchronously, non_constant_identifier_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/auth/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

import '../../utils/global_variables.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  final TextEditingController UsernameController = TextEditingController();
  final TextEditingController BioController = TextEditingController();
  bool isLoading = false;
  Uint8List? _profilePic;

  @override
  void dispose() {
    super.dispose();
    _EmailController.dispose();
    _PasswordController.dispose();
    UsernameController.dispose();
    BioController.dispose();
  }

  void SignUpUser() async {
    String res = await AuthMethods().signUpUser(
        email: _EmailController.text,
        password: _PasswordController.text,
        username: UsernameController.text,
        bio: BioController.text,
        profilePic: _profilePic);

    if (res == 'Success') {
      showSnackBar(context, 'Account created successfully');
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout());
      }));
    } else {
      showSnackBar(context, res);
    }
  }

  void selectImage() async {
    Uint8List im = await PickImage(ImageSource.gallery);
    setState(() {
      _profilePic = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Instagram"),
          backgroundColor: blueColor,
        ),
        body: SafeArea(
            child: Container(
                padding: MediaQuery.of(context).size.width > webscreenWidth
                    ? EdgeInsets.symmetric(horizontal: 400)
                    : EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    Text("Create your account", style: TextStyle(fontSize: 32)),
                    Stack(
                      children: [
                        _profilePic != null
                            ? CircleAvatar(
                                radius: 58,
                                backgroundImage: MemoryImage(_profilePic!))
                            : CircleAvatar(
                                radius: 58,
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png')),
                        Positioned(
                          child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: const Icon(Icons.add_a_photo)),
                          bottom: 0,
                          right: 0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextInput(
                      hint: "Enter your username",
                      Textcontroller: UsernameController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextInput(
                      hint: "Enter you email",
                      Textcontroller: _EmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    TextInput(
                      hint: "Write about yourself",
                      Textcontroller: BioController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextInput(
                      hint: "Password",
                      Textcontroller: _PasswordController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        SignUpUser();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: isLoading
                            ? Center(
                                child: Container(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                height: 16,
                                width: 16,
                              ))
                            : Text("Sign Up"),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(75))),
                            color: blueColor),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(color: blueColor),
                            ))
                      ],
                    ),
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                  ],
                ))));
  }
}

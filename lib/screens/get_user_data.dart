// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_final_fields, avoid_unnecessary_containers, use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen_layout.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/resources/update_user_data.dart';

import '../responsive/web_screen_layout.dart';

class getUserData extends StatefulWidget {
  const getUserData({super.key});

  @override
  State<getUserData> createState() => _getUserDataState();
}

class _getUserDataState extends State<getUserData> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  UserDetails userDetails = UserDetails();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(child: Container(), flex: 2),
            Text(
              "Add your details",
              style: TextStyle(fontSize: 44),
            ),
            SizedBox(
              height: 38,
            ),
            TextInput(
                hint: "Username",
                Textcontroller: _userNameController,
                keyboardType: TextInputType.text),
            SizedBox(
              height: 24,
            ),
            TextInput(
                hint: "Bio",
                Textcontroller: _bioController,
                keyboardType: TextInputType.text),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                String res = await userDetails.updateUser(
                    username: _userNameController.text,
                    Bio: _bioController.text);
                if (res == "Success") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResponsiveLayout(
                                mobileScreenLayout: MobileScreenLayout(),
                                webScreenLayout: WebScreenLayout(),
                              )));
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(res)));
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Container(
                  child: Center(
                    child: isLoading
                        ? Center(
                            child: Container(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              height: 18,
                              width: 18,
                            ),
                          )
                        : Text("next"),
                  ),
                  width: double.infinity,
                  height: 32,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.blue)),
            ),
            Flexible(child: Container(), flex: 2),
          ],
        ),
      )),
    );
  }
}

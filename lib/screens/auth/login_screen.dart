// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _EmailController.dispose();
    _PasswordController.dispose();
  }

  void login() async {
    String res = await AuthMethods().signInUser(
        email: _EmailController.text, password: _PasswordController.text);
    if (res == "Success") {
      showSnackBar(context, "Login Successful");
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout())));
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              flex: 2,
            ),
            Text("Login to your account", style: TextStyle(fontSize: 44)),
            //text field input for email
            SizedBox(
              height: 52,
            ),
            TextInput(
              hint: "Enter you email",
              Textcontroller: _EmailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 28,
            ),
            //text field input for password
            TextInput(
              hint: "Password",
              Textcontroller: _PasswordController,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
            ),
            SizedBox(
              height: 26,
            ),
            //button to login
            InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await Future.delayed(Duration(seconds: 1));
                login();
                setState(() {
                  isLoading = false;
                });
              },
              child: Container(
                child: isLoading
                    ? Center(
                        child: Container(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ))
                    : Text("Login"),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(75))),
                    color: blueColor),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text("Sign up", style: TextStyle(color: blueColor)),
                )
              ],
            ),
            Flexible(child: Container(), flex: 1),
            //button to sign up
          ],
        ),
      )),
    );
  }
}

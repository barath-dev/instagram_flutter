// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, sort_child_properties_last

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textcolor;
  final Function() function;
  const FollowButton({
    Key? key,
    required Color this.backgroundColor,
    required Color this.borderColor,
    required String this.text,
    required Color this.textcolor,
    required Function() this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
      onPressed: function,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          "${text}",
          style: TextStyle(
            color: textcolor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        width: 230,
        height: 27,
      ),
    ));
  }
}

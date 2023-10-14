// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

PickImage(ImageSource source) async {
  final ImagePicker _ImagePicker = ImagePicker();

  XFile? _file = await _ImagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    print("No image selected");
  }
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$content"),
  ));
}

toast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.greenAccent,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_tutorial/models/image_picker_home.dart';
import 'package:flutter/material.dart';

class home_screen extends StatefulWidget {
  home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

File? _selected_image_home;

class _home_screenState extends State<home_screen> {
  void image_upload() async {
    final storageRef = FirebaseStorage.instance.ref().child('upload_image');
    await storageRef.putFile(_selected_image_home!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              )),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Column(children: [
        Center(
          child: home_image_picker(
            onpickimage: (_selected_image) =>
                _selected_image_home = _selected_image,
          ),
        ),
        if (_selected_image_home != null)
          Expanded(child: Container(child: Image.file(_selected_image_home!))),
        ElevatedButton(
            onPressed: () {
              image_upload();
            },
            child: Text('UPLOAD'))
      ])),
    );
  }
}

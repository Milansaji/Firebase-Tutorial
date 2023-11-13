import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_tutorial/models/iamge_picker.dart';

import 'package:flutter/material.dart';

final _auth = FirebaseAuth.instance;

class auth extends StatefulWidget {
  auth({
    super.key,
  });

  @override
  State<auth> createState() => _homeState();
}

class _homeState extends State<auth> {
  bool _old_client = false;

  final _formkey = GlobalKey<FormState>();
  var _enteremail = '';
  var _enterpassword = '';
  bool _isAuthing = false;
  var _enterUsername = '';
  // ignore: non_constant_identifier_names
  File? _selected_image_auth;
  void _submit() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid || _old_client && _selected_image_auth == null) {
      return;
    }

    _formkey.currentState!.save();

    try {
      setState(() {
        _isAuthing = true;
      });
      if (_old_client) {
        final UserCredential userInfo = await _auth.signInWithEmailAndPassword(
            email: _enteremail, password: _enterpassword);
      } else {
        final UserCredential userInfo =
            await _auth.createUserWithEmailAndPassword(
                email: _enteremail, password: _enterpassword);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${userInfo.user!.uid}.jpg');
        await storageRef.putFile(_selected_image_auth!);
        final imageurl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userInfo.user!.uid)
            .set({
          'username ': _enterUsername,
          'email': _enteremail,
          'image url ': imageurl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed.')));
      }
      setState(() {
        _isAuthing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_old_client)
              Image_picker(
                onpickimage: (_selected_image) =>
                    _selected_image_auth = _selected_image,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'please enter a valid mail ';
                  }
                  return null;
                },
                onSaved: (Value) {
                  _enteremail = Value!;
                },
                decoration: InputDecoration(
                    hintText: 'Enter email/phone number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'password need 10 character';
                  }
                  return null;
                },
                onSaved: (Value) => _enterpassword = Value!,
                decoration: InputDecoration(
                    hintText: 'Enter password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            if (!_old_client)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  enableSuggestions: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return 'please enter least 4 character';
                    }
                    return null;
                  },
                  onSaved: (Value) {
                    _enterUsername = Value!;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            if (_isAuthing) CircularProgressIndicator(),
            ElevatedButton(
                onPressed: () => _submit(),
                child: Text(_old_client ? "Login" : "signup")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_old_client
                    ? "Create a new account"
                    : "Already have an account"),
                if (!_isAuthing)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _old_client = !_old_client;
                      });
                    },
                    child: Text(
                      'Click here..',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
              ],
            ),
          ],
        ),
      )),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/screens/auth_screen.dart';
import 'package:firebase_tutorial/screens/home_screen.dart';
import 'package:firebase_tutorial/screens/splash.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return splash_screen();
              }
              if (snapshot.hasData) {
                return home_screen();
              } else {
                return auth();
              }
            }));
  }
}

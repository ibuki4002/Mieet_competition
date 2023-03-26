import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_twitter/vew/review/add_book.dart';
import 'package:flutter_app_twitter/vew/review/add_review.dart';
import 'package:flutter_app_twitter/vew/review/review.dart';
import 'package:flutter_app_twitter/vew/review/screen.dart';
import 'package:flutter_app_twitter/vew/start_up/login_page.dart';


//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';

//import 'dart:async';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}


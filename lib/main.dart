import 'package:cinematch/screens/auth/WelcomePage.dart';
import 'package:flutter/material.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cinematch',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new WelcomePage(),
    );
  }
}
import 'package:cinematch/screens/auth/LoginPage.dart';
import 'package:cinematch/screens/auth/RegisterPage.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cinematch'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new RaisedButton(
            child: new Text('Login ', style: new TextStyle(fontSize: 20)),
            onPressed: goToLoginPage,
          ),
          new RaisedButton(
            child: new Text('Register ', style: new TextStyle(fontSize: 20)),
            onPressed: goToRegisterPage,
          ),
        ],
      ),
    );
  }

  void goToLoginPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  void goToRegisterPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPage(), fullscreenDialog: true));
  }
}

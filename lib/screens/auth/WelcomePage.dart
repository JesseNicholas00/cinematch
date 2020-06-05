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
    return Container(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Image.asset('assets/images/nama_logo.png'),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50), 
            ),
            Container(
              child: new RaisedButton(
                child: new Text('login ', style: new TextStyle(fontSize: 20, color: Colors.red[800])),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  ),
                onPressed: goToLoginPage,
              ),
              height: 48.0,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50), 
            ),
            Container(
              child: new RaisedButton(
                child: new Text('register ', style: new TextStyle(fontSize: 20, color: Colors.red[800])),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  ),
                onPressed: goToRegisterPage,
              ),
              height: 48.0,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 50)

            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_welcomePage.jpg'),
          fit: BoxFit.fill,
        ),
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

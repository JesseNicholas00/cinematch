import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'auth/WelcomePage.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('SETTINGS', style: TextStyle(color: Colors.grey[900])),
          backgroundColor: Colors.grey[200],
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              child: RaisedButton(
                color: Colors.grey[50],
                onPressed: () {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Wait!",
                    desc: "Are you sure you want to log out?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      WelcomePage()),
                              ModalRoute.withName('/'));
                        },
                        color: Colors.red[800],
                      ),
                      DialogButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red[800],
                      )
                    ],
                  ).show();
                },
                child: Text("Log Out"),
              ),
            ),
          ],
        ));
  }
}

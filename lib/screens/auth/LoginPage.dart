import 'package:cinematch/screens/Index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  Future<void> login() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;

        assert(user != null);
        assert(await user.getIdToken() != null);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Index()));
      } catch (e) {
        print(e.message);
      }
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Login')),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value.isEmpty ? 'No empty emails' : null,
                  onSaved: (value) => _email = value,
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? 'No Empty Password' : null,
                  onSaved: (value) => _password = value,
                ),
                new RaisedButton(
                  child: new Text('Login', style: new TextStyle(fontSize: 20)),
                  onPressed: login,
                )
              ]),
        ),
      ),
    );
  }
}

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
    return new Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            title: Text('LOGIN', style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold)), 
            centerTitle: true,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: Colors.red[800]
            ),
            elevation: 0.0,
            
            ),
          body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: formKey,
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Email",
                          ),
                        validator: (value) =>
                            value.isEmpty ? 'No empty emails' : null,
                        onSaved: (value) => _email = value,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                    ),
                    Container(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                          ),
                        obscureText: true,
                        validator: (value) =>
                            value.isEmpty ? 'No Empty Password' : null,
                        onSaved: (value) => _password = value,
                        ),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                    ),
                    //LOGIN BUTTON
                    Container(
                      child:new RaisedButton(
                        child: new Text('login', style: new TextStyle(fontSize: 20, color: Colors.red[800])),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          ),
                        onPressed: login,
                      ),
                      height: 48.0,
                      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50), 
                    ),
                  ]),
            ),
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
}

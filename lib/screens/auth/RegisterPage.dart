import 'package:cinematch/screens/auth/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinematch/models/Genre.dart';
import 'package:http/http.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterPageState();
}

Future<Map<int, String>> fetchGenreDictionary(Client client) async {
  final response = await client.get(
      "https://api.themoviedb.org/3/genre/movie/list?api_key=47cdc06d19f09328eac1f45414e6593b&language=en-US");

  final parsed = jsonDecode(response.body);
  print(parsed['genres']);

  Map<int, String> genreNameBasedOnId = {};

  for (int i = 0; i < parsed['genres'].length; i++) {
    Genre genre = Genre.fromJson(parsed['genres'][i]);
    genreNameBasedOnId[genre.id] = genre.name;
  }

  return genreNameBasedOnId;
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  Map<int, String> genreDict;

  @override
  void initState() {
    super.initState();
    fetchGenreDictionary(Client()).then((value) => genreDict = value);
  }

  Future<void> register() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;

        user.sendEmailVerification();

        Map<String, dynamic> userInfo;

        userInfo = {
          "preference": {},
          "watchlist": []
        };

        final dbReference = Firestore.instance;

        dbReference.collection("users").document(user.uid).setData(userInfo);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message());
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
        //TITLE
        appBar: new AppBar(
          title: new Text('REGISTER',
              style: TextStyle(
                  color: Colors.red[600], fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.red[800]),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Email",
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'No empty emails' : null,
                        onSaved: (value) => _email = value,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10)),
                  Container(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
                        ),
                        obscureText: true,
                        validator: (value) =>
                            value.isEmpty ? 'No Empty Password' : null,
                        onSaved: (value) => _password = value,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10)),
                  //REGISTER BUTTON
                  Container(
                    child: new RaisedButton(
                      child: new Text('Register',
                          style: new TextStyle(
                              fontSize: 20, color: Colors.red[800])),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: register,
                    ),
                    height: 48.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                  )
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

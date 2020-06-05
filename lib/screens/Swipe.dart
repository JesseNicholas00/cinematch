import 'package:flutter/material.dart';

class Swipe extends StatefulWidget {
  @override
  _SwipeState createState() => _SwipeState();
}

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}

class _SwipeState extends State<Swipe> {
  void _pushSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
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
                  onPressed: () {},
                  child: Text("Preferences"),
                ),
              ),
              Container(
                height: 50,
                child: RaisedButton(
                  color: Colors.grey[50],
                  onPressed: () {},
                  child: Text("Account"),
                ),
              ),
              Container(
                height: 50,
                child: RaisedButton(
                  color: Colors.grey[50],
                  onPressed: () {},
                  child: Text("Help Center"),
                ),
              ),
              Container(
                height: 50,
                child: RaisedButton(
                  color: Colors.grey[50],
                  onPressed: () {},
                  child: Text("Log Out"),
                ),
              ),
            ],
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('CINEMATCH',
              style: TextStyle(
                  color: Colors.red[600], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                onPressed: _pushSettings,
                icon: Icon(Icons.settings, color: Colors.grey))
          ]),
      backgroundColor: Colors.white,
      body: Center(),
    );
  }
}

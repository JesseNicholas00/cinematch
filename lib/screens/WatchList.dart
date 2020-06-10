import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinematch/models/Movie.dart';

final List<String> items = [];

class Watchlist extends StatefulWidget {
  Watchlist({Key key}) : super(key: key);
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<Watchlist> {
  final dbReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WATCHLIST',
              style: TextStyle(
                  color: Colors.red[800], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false
          ),
        
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: UniqueKey(), 
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  items.removeAt(index);
                });
                // Then show a snackbar.
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Show a red background as the item is swiped away.
              background: Container(
                child: Align(
                  alignment: Alignment.centerRight, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text("remove ",
                    style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
              color: Colors.red),
              child: ListTile(title: Text('$item')),
            );
          },
        ),
    );
  }
}

class WatchList extends StatelessWidget {
  const WatchList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('ini')
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<String>> getWatchListItems() async {
  String userId;
  List<String> watchlist = [];
  await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    userId = user.uid;
  });

  DocumentSnapshot doc;

  await Firestore.instance
      .collection("users")
      .document(userId)
      .get()
      .then((DocumentSnapshot ds) {
    doc = ds;
  });

  for (int i = 0; i < doc.data["watchlist"].length; i++) {
    watchlist.add(doc.data["watchlist"][i]["title"]);
  }

  return watchlist;
}

class Watchlist extends StatefulWidget {
  Watchlist({Key key}) : super(key: key);
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<Watchlist> {
  final dbReference = Firestore.instance;
  List<String> watchlist = [];

  @override
  void initState() {
    super.initState();
    List<String> bread;
    getWatchListItems().then((value) {
      for (int i = 0; i < value.length; i++) {
        watchlist.add(value[i]);
      }
    });
    print(bread);
    print(watchlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('WATCHLIST',
              style: TextStyle(
                  color: Colors.red[800], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false),
      body: ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final item = watchlist[index];

          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: UniqueKey(),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                watchlist.removeAt(index);
              });
              // Then show a snackbar.
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("$item dismissed")));
            },
            // Show a red background as the item is swiped away.
            background: Container(
                child: Align(
                  alignment: Alignment
                      .centerRight, // Align however you like (i.e .centerRight, centerLeft)
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
    return Container(child: Text('ini'));
  }
}

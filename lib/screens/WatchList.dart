import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinematch/models/Movie.dart';

Future getWatchListItems() async {
  String userId;
  await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    userId = user.uid;
  });

  var data;

  await Firestore.instance
      .collection("users")
      .document(userId)
      .get()
      .then((DocumentSnapshot ds) {
    data = ds.data['watchlist'];
  });
  return data;
}

void deleteWatchItem(Map<String, dynamic> item) async {
  String userId;
  await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
    userId = user.uid;
  });

  await Firestore.instance.collection("users").document(userId).updateData({
    'watchlist': FieldValue.arrayRemove([item])
  });
}

void updatePreference(data, DismissDirection direction) async {
  Movie movie = Movie.fromJSON(data);
  String userId;
  final Firestore dbReference = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  await auth.currentUser().then((FirebaseUser user) {
    userId = user.uid;
  });

  Future<DocumentSnapshot> userData =
      dbReference.collection('users').document(userId).get();

  Map<String, int> preference = {};
  print(userData);
  userData.then((snapshot) {
    print(snapshot);
    preference = snapshot.data['preference'];
  });
  print(preference);
  if (direction == DismissDirection.startToEnd) {
    print(preference);
    for (int i = 0; i < movie.genreIds.length; i++) {
      String key = movie.genreIds[i].toString();
      if (preference[movie.genreIds[i]] == null) {
        preference.putIfAbsent(key, () => 1);
      } else {
        preference.update(
            key, (value) => (value == null ? 0 : value) + 1);
      }
    }
  } else {
    for (int i = 0; i < movie.genreIds.length; i++) {
      String key = movie.genreIds[i].toString();
      if (preference[movie.genreIds[i]] == null) {
        preference.putIfAbsent(key, () => - 1);
      } else {
        preference.update(
            key, (value) => (value == null ? 0 : value) - 1);
      }
    }
  }

  dbReference
      .collection('users')
      .document(userId)
      .updateData({'preference': preference});
}

class Watchlist extends StatefulWidget {
  Watchlist({Key key}) : super(key: key);
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<Watchlist> {
  final dbReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
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
        body: Container(
          child: FutureBuilder(
            future: getWatchListItems(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data[index]["title"];

                  return Dismissible(
                    //Each Dismissible must contain a Key. Keys allow Flutter to
                    //uniquely identify widgets.
                    key: UniqueKey(),
                    //Provide a function that tells the app
                    //what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        updatePreference(snapshot.data[index], direction);
                        deleteWatchItem(snapshot.data[index]);
                        snapshot.data.removeAt(index);
                      });
                      // Then show a snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("$item dismissed")));
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(
                        child: Align(
                          alignment: Alignment
                              .centerRight, // Align however you like (i.e .centerRight, centerLeft)
                          child: Text("remove ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        color: Colors.red),
                    child: ListTile(title: Text('$item')),
                  );
                },
              );
            },
          ),
        ));
  }
}

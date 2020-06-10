import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinematch/models/Movie.dart';

Future<String> getUID() async {
  
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();

  return user.uid;
}

Stream<DocumentSnapshot> fetchWatchList(String uid)  {

  final dbReference = Firestore.instance;
  
  Stream<DocumentSnapshot> dr = dbReference.collection('users').document(uid).snapshots();
  
  print(dr);
  
  return dr;
}

class Watchlist extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<Watchlist> {
  final dbReference = Firestore.instance;

  Stream<DocumentSnapshot> watchlist;
  String uid;

  @override
  void initState() { 
    super.initState();
    getUID().then((value) => setState((){
      uid = value;
    }));
    watchlist = fetchWatchList(uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: watchlist,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return new Text('Loading...');
        }

        return new Text(snapshot.data['watchlist']);
      },
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
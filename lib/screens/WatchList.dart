import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinematch/models/Movie.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<Watchlist> {
  final dbReference = Firestore.instance;

  List<Movie> watchlist = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dbReference
          .collection("watchlist")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            final dynamic message = document['title'];
            return ListTile(
              trailing: IconButton(
                onPressed: () => document.reference.delete(),
                icon: Icon(Icons.delete),
              ),
              title: Text(
                message != null ? message.toString() : '<No message retrieved>',
              ),
              subtitle: Text('Message ${index + 1} of $messageCount'),
            );
          },
        );
      },
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: ListView(
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Cupcake"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Donus"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Eclair"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Froyo"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Gingerbread"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Honeycomb"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Ice Cream Sandwich"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Jelly Bean"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Jelly Bean"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Kitkat"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Lollipop"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Marshmallow"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Nougat"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Oreo"),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text("Android Pie"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

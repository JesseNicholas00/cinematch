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

    // List<Movie> watchlist = [];
    // return StreamBuilder<QuerySnapshot>(
    //   stream: dbReference
    //       .collection("watchlist")
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
    //     final int messageCount = snapshot.data.documents.length;
    //     return ListView.builder(
    //       itemCount: messageCount,
    //       itemBuilder: (_, int index) {
    //         final DocumentSnapshot document = snapshot.data.documents[index];
    //         final dynamic message = document['title'];
    //         return ListTile(
    //           trailing: IconButton(
    //             onPressed: () => document.reference.delete(),
    //             icon: Icon(Icons.delete),
    //           ),
    //           title: Text(
    //             message != null ? message.toString() : '<No message retrieved>',
    //           ),
    //           subtitle: Text('Message ${index + 1} of $messageCount'),
    //         );
    //       },
    //     );
    //   },
    // );
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

import 'package:flutter/material.dart';

class Watchlist extends StatefulWidget{
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<Watchlist>{
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Cupcake"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Donus"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Eclair"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Froyo"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Gingerbread"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Honeycomb"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Ice Cream Sandwich"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Jelly Bean"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Jelly Bean"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Kitkat"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Lollipop"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Marshmallow"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Nougat"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Oreo"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Android Pie"),
          ),
        ],
      ),
    );
  }
}
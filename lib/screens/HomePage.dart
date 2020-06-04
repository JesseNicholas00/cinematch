import 'package:flutter/material.dart';
import 'package:cinematch/models/ItemModel.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> cardList;
  Client client = Client();
  ItemModel item;

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  Future<ItemModel> getMovies() async {
    final req = await client.get(
        "https://api.themoviedb.org/3/movie/popular?api_key=47cdc06d19f09328eac1f45414e6593b");
    item = ItemModel.fromJSON(json.decode(req.body));

    return Future.value();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<ItemModel>(
          future: getMovies(),
          builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = null;
            }
            else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }

            return Center(
              child: Column(
                children: children,
              ),
            );
          },
        ),
        // child: Stack(
        //   alignment: Alignment.center,
        //   children: cardList,
        // ),
      ),
    );
  }

  List<Widget> _getMatchCard(ItemModel items) {
    for (int x = 0; x < items.results.length && cardList.length < 20; x++) {
      cardList.add(Positioned(
        top: 100,
        child: Draggable(
          onDragEnd: (drag) {
            if (drag.offset.direction > 1) {
              debugPrint("left side");
            } else {
              debugPrint("right side");
            }
            _removeCard(x);
          },
          childWhenDragging: Container(),
          feedback: Card(
            elevation: 12,
            color: Color.fromARGB(255, 0, 0, 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 300,
              height: 400,
            ),
          ),
          child: Card(
            elevation: 12,
            color: Color.fromARGB(255, 0, 0, 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 300,
              height: 400,
            ),
          ),
        ),
      ));
    }
    return cardList;
  }
}

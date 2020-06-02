import 'package:cinematch/bloc/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cinematch/models/ItemModel.dart';

class MatchCard {
  double margin = 0;
  int r = 0;
  int g = 0;
  int b = 0;

  MatchCard(double marginTop, int red, int green, int blue) {
    margin = marginTop;
    r = red;
    b = blue;
    g = green;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> cardList;

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
      if(cardList.length == 0) {
        _getMatchCard();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(bloc.fetchAllMovies());
    cardList = _getMatchCard();
  }

  Widget build(BuildContext context) {
    print(bloc.allMovies);
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: cardList,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder(
  //       stream: bloc.allMovies,
  //       builder: (context, AsyncSnapshot<ItemModel> snapshot) {
  //         if (snapshot.hasData) {
  //           return buildList(snapshot);
  //         } else if (snapshot.hasError) {
  //           return Text(snapshot.error.toString());
  //         }
  //         return Center(child: CircularProgressIndicator());
  //       },
  //     );
  // }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.results.length,
      gridDelegate:
      new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkResponse(
            enableFeedback: true,
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${snapshot.data
                  .results[index].posterPath}',
              fit: BoxFit.cover,
            ),
          ),
        );
      });
  }

  List<Widget> _getMatchCard() {
    List<MatchCard> cards = new List();
    cards.add(MatchCard(10, 0, 0, 255));
    cards.add(MatchCard(20, 0, 255, 0));
    cards.add(MatchCard(30, 255, 0, 0));

    List<Widget> cardList = new List();

    for (int x = 0; x < 3; x++) {
      cardList.add(Positioned(
        top: cards[x].margin,
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
            color: Color.fromARGB(255, cards[x].r, cards[x].g, cards[x].b),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 300,
              height: 400,
            ),
          ),
          child: Card(
            elevation: 12,
            color: Color.fromARGB(255, cards[x].r, cards[x].g, cards[x].b),
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

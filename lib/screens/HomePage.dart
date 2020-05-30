import 'package:flutter/material.dart';

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
    });
  }

  @override
  void initState() {
    super.initState();
    cardList = _getMatchCard();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: cardList,
        ),
      ),
    );
  }

  List<Widget> _getMatchCard() {
    List<MatchCard> cards = new List();
    cards.add(MatchCard(10,0,0,255));
    cards.add(MatchCard(20,0,255,0));
    cards.add(MatchCard(30,255,0,0));

    List<Widget> cardList = new List();

    for (int x = 0; x < 3; x++) {
      cardList.add(Positioned(
        top: cards[x].margin,
        child: Draggable(
          onDragEnd: (drag) {
            if(drag.offset.direction > 1) {
              debugPrint("left side");
            }
            else {
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

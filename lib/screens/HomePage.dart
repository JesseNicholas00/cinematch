import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cinematch/models/Movie.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:rflutter_alert/rflutter_alert.dart';



Future<List<Movie>> fetchMovies(Client client) async {
  final Firestore dbReference = Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String userId;
  await auth.currentUser().then((FirebaseUser user) {
    userId = user.uid;
  });

  DocumentSnapshot ds =
      await dbReference.collection('users').document(userId).get();

  Map<String, dynamic> preference = ds.data['preference'];
  String genreToken = "";

  preference.forEach((key, value) {
    if (value < 0) genreToken += key + ",";
  });

  final response = await client.get(
      'https://api.themoviedb.org/3/discover/movie?api_key=47cdc06d19f09328eac1f45414e6593b&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&without_genres=$genreToken');
  final parsed = jsonDecode(response.body);

  List<Movie> watchlist = [];

  for (int i = 0; i < ds.data['watchlist'].length; i++) {
    watchlist.add(Movie.fromJSON(ds.data['watchlist'][i]));
  }

  List<Movie> movies = [];

  for (int i = 0; i < parsed['results'].length; i++) {
    Movie movie = Movie.fromJSON(parsed['results'][i]);
    bool containedInWatchlist = false;
    for (var item in watchlist) {
      if (movie.id == item.id) {
        containedInWatchlist = true;
        break;
      }
    }
    if (!containedInWatchlist) movies.add(movie);
  }

  return movies;
}

CardController curr;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> cardList;
  Client client = Client();
  Future<List<Movie>> movies;
  List<Movie> watchlist = [];

  @override
  void initState() {
    super.initState();
    movies = fetchMovies(Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text('CINEMATCH',
                style: TextStyle(
                    color: Colors.red[800], fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  },
                  icon: Icon(Icons.settings, color: Colors.grey))
            ]),
        body: FutureBuilder<List<Movie>>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Text('no data');
              } else {
                return MovieCardList(movies: snapshot.data, context: context);
              }
            } else {
              return Center(child: CircularProgressIndicator()); // loading
            }
          },
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: FloatingActionButton(
            onPressed: () {
              curr.triggerLeft();
            },
            heroTag: "btn_no",
            child: Icon(Icons.cancel),
            backgroundColor: Colors.red,
          )),
          Expanded(
              child: FloatingActionButton(
            onPressed: () {
              curr.triggerRight();
            },
            heroTag: "btn_yes",
            child: Icon(Icons.favorite),
            backgroundColor: Colors.green,
          )),
        ]));
  }
}

class MovieCardList extends StatelessWidget {
  final List<Movie> movies;
  final BuildContext context;
  const MovieCardList({Key key, @required this.movies, @required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CardController controller = CardController();
    curr = controller;

    void addToWatchList(Movie movie) async {
      final dbReference = Firestore.instance;
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();

      dbReference.collection("users").document(user.uid).updateData({
        'watchlist': FieldValue.arrayUnion([movie.data])
      });
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: new TinderSwapCard(
        orientation: AmassOrientation.BOTTOM,
        totalNum: movies.length,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.width * 1.2,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 0.9,
        cardBuilder: (context, index) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            child: Scrollbar(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.network(
                            'https://image.tmdb.org/t/p/w185/${movies[index].posterPath}',
                            fit: BoxFit.fitWidth),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            '${movies[index].originalTitle.toUpperCase()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontStyle: FontStyle.italic)),
                      ),
                      SizedBox(height: 5),
                      Text('(${movies[index].releaseDate.substring(0, 4)})',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              fontStyle: FontStyle.italic)),
                      Text('Rating: ${movies[index].voteAverage}/10',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontStyle: FontStyle.italic)),
                      SizedBox(height: 5),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '${movies[index].overview}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ))
                    ],
                  )),
              //isAlwaysShown: true,
            )),
        cardController: controller,
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          if (orientation == CardSwipeOrientation.RIGHT) {
            addToWatchList(movies[index]);
          }
        },
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          curr = controller;
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('SETTINGS', style: TextStyle(color: Colors.grey[900])),
          backgroundColor: Colors.grey[200],
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              child: RaisedButton(
                color: Colors.grey[50],
                onPressed: () {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Wait!",
                    desc: "Are you sure you want to log out?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, "/logout"),
                        color: Colors.red[800],
                      ),
                      DialogButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red[800],
                      )
                    ],
                  ).show();
                },
                child: Text("Log Out"),
              ),
              margin: EdgeInsets.all(20),
            ),
          ],
        ));
  }
}



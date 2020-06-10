import 'package:cinematch/screens/Index.dart';
import 'package:flutter/material.dart';
import 'package:cinematch/models/Movie.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'WatchList.dart';

Future<List<Movie>> fetchMovies(Client client) async {
  final response = await client.get(
      'https://api.themoviedb.org/3/movie/popular?api_key=47cdc06d19f09328eac1f45414e6593b&language=en-US&page=1');
  final parsed = jsonDecode(response.body);

  List<Movie> movies = [];

  for (int i = 0; i < parsed['results'].length; i++) {
    Movie movie = Movie.fromJSON(parsed['results'][i]);
    movies.add(movie);
  }

  return movies;
}

//maaf ni haram bgt gua pakek global variable :(
CardController curr;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> cardList;
  Client client = Client();
  Future<List<Movie>> movies;
  //----------------------coba disaster
  // void _pushSettings() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => temp()),);
  // }
  //----------------------end disaster
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
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()),);
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
            return Center(child:CircularProgressIndicator()); // loading
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: FloatingActionButton(
            onPressed: () {
              curr.triggerLeft();
            },
            heroTag: "btn_no",
            child: Icon(Icons.cancel),
            backgroundColor: Colors.red,
          )),
          Expanded(child: FloatingActionButton(
            onPressed: () {
              curr.triggerRight();
            },
            heroTag: "btn_yes",
            child: Icon(Icons.favorite),
            backgroundColor: Colors.green,
          )),
        ])
    );
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
    int choosenIndex;

    void addToWatchList(Movie movie) async {
      final dbReference = Firestore.instance;
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();

      dbReference.collection("users").document(user.uid).updateData({'watchlist': movie.data});
    }

    void updatePreference(Movie movie, String status) async {
      final dbReference = Firestore.instance;
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();

      dbReference.collection("users").document(user.uid).updateData({
          "preference": FieldValue.arrayUnion([movie.getData])
        }
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: new TinderSwapCard(
        orientation: AmassOrientation.BOTTOM,
        totalNum: movies.length,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.width * 2,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 1,
        cardBuilder: (context, index) => Card(
          elevation: 5.0,
          child: Column(children: <Widget>[
            Image.network('https://image.tmdb.org/t/p/w185/${movies[index].posterPath}'),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('${movies[index].originalTitle.toUpperCase()}', textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.red[800], fontWeight: FontWeight.bold, fontSize: 20, fontStyle: FontStyle.italic)),
            
            ),
            Text('(${movies[index].releasDate.substring(0,4)})',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 10, fontStyle: FontStyle.italic)),
            Text('Rating: ${movies[index].popularity.round()}/100',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15, fontStyle: FontStyle.italic)),
          ],
      
          )
        ),
        cardController: controller,
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          choosenIndex = index;
        },
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          curr = controller;
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            String temp = '${movies[choosenIndex].originalTitle.toUpperCase()}';
            if(!items.isEmpty){
              if(!items.contains(temp)){
                items.add(temp);
                print(choosenIndex);
              }
            }
            else{
              items.add(temp);
            }
          }
          }
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
              onPressed: () {},
              child: Text("Preferences"),
            ),
          ),
          Container(
            height: 50,
            child: RaisedButton(
              color: Colors.grey[50],
              onPressed: () {},
              child: Text("Account"),
            ),
          ),
          Container(
            height: 50,
            child: RaisedButton(
              color: Colors.grey[50],
              onPressed: () {},
              child: Text("Help Center"),
            ),
          ),
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
                      onPressed: () => Navigator.pushReplacementNamed(context, "/logout"),
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
          ),
        ],
      )
    );
  }
}

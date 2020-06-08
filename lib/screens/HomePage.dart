import 'package:flutter/material.dart';
import 'package:cinematch/models/Movie.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_tindercard/flutter_tindercard.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> cardList;
  Client client = Client();
  Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    movies = fetchMovies(Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Search Bar'),
      ),
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
            return CircularProgressIndicator(); // loading
          }
        },
      ),
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: new TinderSwapCard(
        orientation: AmassOrientation.BOTTOM,
        totalNum: movies.length,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.width * 0.9,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 0.8,
        cardBuilder: (context, index) => Card(
          child: Image.asset('https://image.tmdb.org/t/p/w185${movies[index].posterPath}'),
        ),
        cardController: controller,
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          /// Get orientation & index of swiped card!
        },
      ),
    );
  }
}

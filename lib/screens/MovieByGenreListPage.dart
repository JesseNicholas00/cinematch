import 'package:flutter/material.dart';
import 'package:cinematch/models/Movie.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:cinematch/screens/MovieDetailPage.dart';

Future<List<Movie>> fetchMoviesByGenre(Client client, int genreId) async {
  final response = await client.get(
      'https://api.themoviedb.org/3/discover/movie?api_key=47cdc06d19f09328eac1f45414e6593b&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=' + genreId.toString());

  final parsed = jsonDecode(response.body);

  List<Movie> movies = [];

  for (int i = 0; i < parsed['results'].length; i++) {
    Movie movie = Movie.fromJSON(parsed['results'][i]);
    movies.add(movie);
  }

  return movies;
}

class MovieByGenreListPage extends StatefulWidget {
  final int genreId;

  MovieByGenreListPage({Key key, @required this.genreId}) : super(key: key);

  @override
  _MovieByGenreListPageState createState() => _MovieByGenreListPageState(genreId);
}

class _MovieByGenreListPageState extends State<MovieByGenreListPage> {
  Future<List<Movie>> movies;

  final genreId;

  _MovieByGenreListPageState(this.genreId);

  @override
  void initState() {
    super.initState();
    movies = fetchMoviesByGenre(Client(), genreId);
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
              return MovieList(movies: snapshot.data, context: context);
            }
          } else {
            return CircularProgressIndicator(); // loading
          }
        },
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final BuildContext context;

  MovieList({Key key, this.movies, this.context}) : super(key: key);

  void goToMovieDetailPage(Movie movie) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie,)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: InkResponse(
            splashColor: Colors.red,
            enableFeedback: true,
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${movies[index].posterPath}',
              fit: BoxFit.cover,
            ),
            onTap: () => goToMovieDetailPage(movies[index]),
          ),
        );
      });
  }
}

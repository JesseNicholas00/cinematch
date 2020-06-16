import 'package:flutter/material.dart';
import 'package:cinematch/models/Movie.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:cinematch/models/Genre.dart';
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

Future<Map<int,String>> fetchGenreDictionary(Client client) async {
  final response = await client.get(
      "https://api.themoviedb.org/3/genre/movie/list?api_key=47cdc06d19f09328eac1f45414e6593b&language=en-US");

  final parsed = jsonDecode(response.body);
  print(parsed['genres']);

  Map<int,String> genreNameBasedOnId = {};

  for (int i = 0; i < parsed['genres'].length; i++) {
    Genre genre = Genre.fromJson(parsed['genres'][i]);
    genreNameBasedOnId[genre.id] = genre.name;
  }

  return genreNameBasedOnId;
}

class MovieByGenreListPage extends StatefulWidget {
  final int genreId;

  MovieByGenreListPage({Key key, @required this.genreId}) : super(key: key);

  @override
  _MovieByGenreListPageState createState() => _MovieByGenreListPageState(genreId);
}

class _MovieByGenreListPageState extends State<MovieByGenreListPage> {
  Future<List<Movie>> movies;
  Map<int, String> genreDict;

  final genreId;

  _MovieByGenreListPageState(this.genreId);

  @override
  void initState() {
    super.initState();
    movies = fetchMoviesByGenre(Client(), genreId);
    fetchGenreDictionary(Client()).then((response) {
      genreDict = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    String genreChoosen = "genreDict[genreId]";
    return Scaffold(
      appBar: AppBar(
          title: Text(genreChoosen,
              style: TextStyle(
                  color: Colors.red[800], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false
          ),
      body: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Text('no data');
            } else {
              return MovieList(movies: snapshot.data, context: context, genreDict: genreDict);
            }
          } else {
            return Center(child:CircularProgressIndicator()); // loading
          }
        },
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final BuildContext context;
  final Map<int,String> genreDict;

  MovieList({Key key, this.movies, this.context, this.genreDict}) : super(key: key);

  void goToMovieDetailPage(Movie movie, Map<int,String> genreDict) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie,genreDict: genreDict,)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3/6,
            ),
      itemCount: movies.length, 
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: InkResponse(
              customBorder: null,
              splashColor: Colors.red[800],
              enableFeedback: true,
              child: Container( 
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight:  Radius.circular(20)),
                      child:Image.network(
                        'https://image.tmdb.org/t/p/w185${movies[index].posterPath}',
                        fit: BoxFit.fitWidth,),  
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: Text('${movies[index].originalTitle} (${movies[index].releaseDate.substring(0,4)})', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15, )),
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.center
                    )
                  ],),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 0), 
                    ),
                  ],
                ),
                
              ),
              onTap: () => goToMovieDetailPage(movies[index], genreDict),
            ),
          padding: EdgeInsets.all(4),
        );
      });
  }
}

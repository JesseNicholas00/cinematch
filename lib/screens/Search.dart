import 'package:flutter/material.dart';
import 'package:cinematch/models/Genre.dart';
import 'dart:async';
import 'package:cinematch/screens/MovieByGenreListPage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' show Client;

Future<List<Genre>> fetchGenres(Client client) async {
  final response = await client.get(
      "https://api.themoviedb.org/3/genre/movie/list?api_key=47cdc06d19f09328eac1f45414e6593b&language=en-US");

  final parsed = jsonDecode(response.body);
  print(parsed['genres']);

  List<Genre> genres = [];

  for (int i = 0; i < parsed['genres'].length; i++) {
    Genre genre = Genre.fromJson(parsed['genres'][i]);
    genres.add(genre);
  }

  return genres;
}

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<List<Genre>> genres;

  @override
  void initState() {
    super.initState();
    genres = fetchGenres(Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('SEARCH',
              style: TextStyle(
                  color: Colors.red[800], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false
          ),
      body: FutureBuilder<List<Genre>>(
        future: genres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Text('no data');
            } else {
              return GenreList(genres: snapshot.data, context: context);
            }
          } else {
            return Center(child: CircularProgressIndicator()); // loading
          }
        },
      ),
    );
  }
}

class GenreList extends StatelessWidget {
  final List<Genre> genres;
  final BuildContext context;

  GenreList({Key key, this.genres, this.context}) : super(key: key);

  void goToMovieByGenreListPage(int id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MovieByGenreListPage(genreId: id)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () => goToMovieByGenreListPage(genres[index].id),
            child: Card(
              color: Colors.red[800],
              child: Container(
                padding: EdgeInsets.all(4),
                child: Center(
                  child: Text(genres[index].name.toUpperCase(), style: TextStyle(color: Colors.white),),
                ),
              ),
            ));
      },
    );
  }
}

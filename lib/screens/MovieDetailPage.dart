import 'package:flutter/material.dart';
import 'package:cinematch/models/Movie.dart';

class MovieDetailPage extends StatelessWidget {

  final Movie movie;
  final Map<int,String> genreDict;

  MovieDetailPage({Key key, this.movie, this.genreDict}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    List<String> genres = [];

    for (int i = 0; i < movie.genreIds.length; i++) {
      genres.add(genreDict[movie.genreIds[i]]);
    }
    String movieTitleAppBar = movie.originalTitle.toUpperCase() + " (" + movie.releaseDate.substring(0,4) + ")";
    return Container( 
      child: Scaffold(
        appBar: AppBar(
          title: Text(movieTitleAppBar,
              style: TextStyle(
                  color: Colors.red[800], fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.grey),
          
          ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView( child: new Column(
            children: <Widget>[
              Container(child: Image(
                  image: NetworkImage('https://image.tmdb.org/t/p/w185/${movie.posterPath}'),
                  fit: BoxFit.fill,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(0),
              ),
              new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column( 
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      '${movie.title} (${movie.releaseDate.substring(0,4)})', textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('GENRE(s): '+
                      genres.reduce((value, element) => value + ', ' + element),textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'RATING: ${movie.voteAverage}/10',textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'SYNOPSIS: ${movie.overview}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black54),
                    )
                  ]
              
              )),
              
        ]
    ))
    ),
    padding: EdgeInsets.all(0),
    color: Colors.white,
    );
  }
}
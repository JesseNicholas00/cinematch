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

    return Scaffold(
        body: new Row(
            children: <Widget>[
              Image.network('https://image.tmdb.org/t/p/w185/${movie.posterPath}'),
              new Row(
                  children: <Widget>[
                    Text(
                      'Rating: ${movie.voteAverage}/5',
                      //style: TextStyle(),
                    ),
                    Text(
                      '${movie.title} (${movie.releaseDate})',
                      //style: TextStyle(),
                    ),
                    Text(
                      '${movie.originalTitle} (Original Title)',
                      //style: TextStyle(),
                    ),
                    Text(
                      genres.reduce((value, element) => value + ',' + element)
                      //style: TextStyle(),
                    ),
                  ]
              ),
              Text(
                '${movie.overview}',
                textAlign: TextAlign.justify,
              )
        ]
    )
    );
  }
}
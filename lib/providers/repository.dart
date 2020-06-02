import 'dart:async';
import 'package:cinematch/models/ItemModel.dart';
import 'package:cinematch/providers/MovieApiProvider.dart';

class Repository{
  final movieApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies () => movieApiProvider.fetchMovieList(); 
}
import 'package:cinematch/config.dart';
import 'package:cinematch/models/ItemModel.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class MovieApiProvider{
  Client client = Client();
  final _apiKey = API_KEY;
  final _baseURL = MOVIE_DB_BASE_URL;

  Future<ItemModel> fetchMovieList() async{
    final response = await client
        .get("$_baseURL/movie/popular?api_key=$_apiKey");

    if(response.statusCode == 200){
      return ItemModel.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to load data');
    }
  }

  Future<ItemModel> fetchGenreList() async{
    final response = await client
        .get("$_baseURL/movie/popular?api_key=$_apiKey");

    if(response.statusCode == 200){
      return ItemModel.fromJSON(json.decode(response.body));
    }
    else{
      throw Exception('failed to load data');
    }
  }
}
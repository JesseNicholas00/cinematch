import 'package:cinematch/models/ItemModel.dart';
import 'package:cinematch/providers/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get allMovies => _moviesFetcher.stream;

  fetchAllMovies() async{
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }

  dispose() {
    _moviesFetcher?.close();
  }
}

final bloc = MoviesBloc();
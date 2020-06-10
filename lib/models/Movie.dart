class Movie {
  int _voteCount;
  int _id;
  bool _video;
  var _voteAverage;
  String _title;
  double _popularity;
  String _posterPath;
  String _originalLanguage;
  String _originalTitle;
  List<int> _genreIds = [];
  String _backdropPath;
  bool _adult;
  String _overview;
  String _releaseDate;

  Map<String,dynamic> data;

  Movie.fromJSON(Map<String, dynamic> movie) {
    _voteCount = movie['vote_count'];
    _id = movie['id'];
    _video = movie['video'];
    _voteAverage = movie['vote_average'];
    _title = movie['title'];
    _popularity = movie['popularity'];
    _posterPath = movie['poster_path'];
    _originalLanguage = movie['original_language'];
    _originalTitle = movie['original_title'];

    for (int i = 0; i < movie['genre_ids'].length; i++) {
      _genreIds.add(movie['genre_ids'][i]);
    }

    _backdropPath = movie['backdrop_path'];
    _adult = movie['adult'];
    _overview = movie['overview'];
    _releaseDate = movie['release_date'];

    data = movie;
  }

  Map<String, dynamic> get getData => data;

  String get releasDate => _releaseDate;

  String get overview => _overview;

  bool get adult => _adult;

  String get backdropPath => _backdropPath;

  List<int> get genreIds => _genreIds;

  String get originalTitle => _originalTitle;

  String get originalLanguage => _originalLanguage;

  String get posterPath => _posterPath;

  double get popularity => _popularity;

  String get title => _title;

  double get voteAverage => _voteAverage.toDouble();

  bool get video => _video;

  int get id => _id;

  int get voteCount => _voteCount;
}

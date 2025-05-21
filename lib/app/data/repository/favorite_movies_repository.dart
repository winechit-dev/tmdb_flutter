import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';
import 'package:tmdb_flutter/app/data/local/favorite_movies_local_data_source.dart';

class FavoriteMoviesRepository {
  FavoriteMoviesRepository(this._localDataSource);

  final FavoriteMoviesLocalDataSource _localDataSource;

  Future<void> addFavoriteMovie(Movie movie) async {
    await _localDataSource.addFavoriteMovie({
      'movieId': movie.id,
      'title': movie.title,
      'posterPath': movie.posterPath,
      'overview': movie.overview,
      'voteAverage': movie.voteAverage,
      'releaseDate': movie.releaseDate,
    });
  }

  Future<void> removeFavoriteMovie(int movieId) async {
    await _localDataSource.removeFavoriteMovie(movieId);
  }

  Future<List<Movie>> getFavoriteMovies() async {
    final movies = await _localDataSource.getFavoriteMovies();
    return movies.map((movie) => Movie(
      id: movie['movieId'] as int,
      title: movie['title'] as String,
      posterPath: movie['posterPath'] as String?,
      overview: movie['overview'] as String,
      voteAverage: movie['voteAverage'] as double,
      releaseDate: movie['releaseDate'] as String?,
    )).toList();
  }

  Future<bool> isMovieFavorite(int movieId) async {
    return _localDataSource.isMovieFavorite(movieId);
  }
} 
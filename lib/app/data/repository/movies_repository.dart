import 'package:tmdb_flutter/app/data/local/favorite_movies_local_data_source.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';
import 'package:tmdb_flutter/app/data/remote/movie_api.dart';

class MoviesRepository {
  MoviesRepository(this._localDataSource, this._movieAPI);

  final FavoriteMoviesLocalDataSource _localDataSource;
  final MovieAPI _movieAPI;

  // Favorite movies methods
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
    return movies
        .map((movie) => Movie(
              id: movie['movieId'] as int,
              title: movie['title'] as String,
              posterPath: movie['posterPath'] as String?,
              overview: movie['overview'] as String,
              voteAverage: movie['voteAverage'] as double,
              releaseDate: movie['releaseDate'] as String?,
            ))
        .toList();
  }

  Future<bool> isMovieFavorite(int movieId) async {
    return _localDataSource.isMovieFavorite(movieId);
  }

  // Movie API methods
  Future<MoviesResponse> getTrendingTodayMovies({
    int page = MovieAPI.STARTING_PAGE_INDEX,
    String language = MovieAPI.LANGUAGE,
  }) async {
    return _movieAPI.getTrendingTodayMovies(page: page, language: language);
  }

  Future<MoviesResponse> getPopularMovies({int page = 1}) async {
    return _movieAPI.getPopularMovies(page: page);
  }

  Future<MoviesResponse> getUpcomingMovies({
    int page = MovieAPI.STARTING_PAGE_INDEX,
    String language = MovieAPI.LANGUAGE,
  }) async {
    return _movieAPI.getUpcomingMovies(page: page, language: language);
  }

  Future<MoviesResponse> getTopRatedMovies({
    int page = MovieAPI.STARTING_PAGE_INDEX,
    String language = MovieAPI.LANGUAGE,
  }) async {
    return _movieAPI.getTopRatedMovies(page: page, language: language);
  }

  Future<MoviesResponse> getNowPlayingMovies({
    int page = MovieAPI.STARTING_PAGE_INDEX,
    String language = MovieAPI.LANGUAGE,
  }) async {
    return _movieAPI.getNowPlayingMovies(page: page, language: language);
  }

  Future<GenresResponse> getMovieGenres({
    String language = MovieAPI.LANGUAGE,
  }) async {
    return _movieAPI.getMovieGenres(language: language);
  }

  Future<MovieDetailsResponse> getMovieDetails(int movieId) async {
    return _movieAPI.getMovieDetails(movieId);
  }

  Future<CreditsResponse> getMovieCredits(int movieId) async {
    return _movieAPI.getMovieCredits(movieId);
  }

  Future<MoviesResponse> getRecommendations({
    required int movieId,
    int page = MovieAPI.STARTING_PAGE_INDEX,
    String language = MovieAPI.LANGUAGE,
  }) async {
    return _movieAPI.getRecommendations(
      movieId: movieId,
      page: page,
      language: language,
    );
  }

  Future<MoviesResponse> searchMovie({
    required String query,
    int page = MovieAPI.STARTING_PAGE_INDEX,
  }) async {
    return _movieAPI.searchMovie(query: query, page: page);
  }
}

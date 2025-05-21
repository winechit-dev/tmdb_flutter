import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/api/models/movie_responses.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_state.dart';
import 'package:tmdb_flutter/app/data/repository/favorite_movies_repository.dart';

class FavoriteMoviesCubit extends Cubit<FavoriteMoviesState> {
  FavoriteMoviesCubit(this._repository) : super(FavoriteMoviesInitial());

  final FavoriteMoviesRepository _repository;

  Future<void> loadFavoriteMovies() async {
    try {
      emit(FavoriteMoviesLoading());
      final movies = await _repository.getFavoriteMovies();
      final favoriteMovieIds = movies.map((m) => m.id).toSet();
      emit(FavoriteMoviesLoaded(
        movies: movies,
        favoriteMovieIds: favoriteMovieIds,
      ));
    } catch (e) {
      emit(FavoriteMoviesError(e.toString()));
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    try {
      final isFavorite = await _repository.isMovieFavorite(movie.id);
      if (isFavorite) {
        await _repository.removeFavoriteMovie(movie.id);
      } else {
        await _repository.addFavoriteMovie(movie);
      }
      await loadFavoriteMovies();
    } catch (e) {
      emit(FavoriteMoviesError(e.toString()));
    }
  }

  Future<bool> isMovieFavorite(int movieId) async {
    return _repository.isMovieFavorite(movieId);
  }
} 
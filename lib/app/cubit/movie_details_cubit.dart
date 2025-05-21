import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/data/repository/movies_repository.dart';
import 'package:tmdb_flutter/app/cubit/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit(this._repository) : super(MovieDetailsInitial());

  final MoviesRepository _repository;

  Future<void> loadMovieDetails(int movieId) async {
    try {
      emit(MovieDetailsLoading());
      final movieDetails = await _repository.getMovieDetails(movieId);
      final credits = await _repository.getMovieCredits(movieId);
      emit(MovieDetailsLoaded(
        movieDetails: movieDetails,
        credits: credits,
      ));
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }
} 
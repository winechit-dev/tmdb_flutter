import 'package:equatable/equatable.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';

abstract class FavoriteMoviesState extends Equatable {
  const FavoriteMoviesState();

  @override
  List<Object?> get props => [];
}

class FavoriteMoviesInitial extends FavoriteMoviesState {}

class FavoriteMoviesLoading extends FavoriteMoviesState {}

class FavoriteMoviesLoaded extends FavoriteMoviesState {
  const FavoriteMoviesLoaded({
    required this.movies,
    required this.favoriteMovieIds,
  });

  final List<Movie> movies;
  final Set<int> favoriteMovieIds;

  @override
  List<Object?> get props => [movies, favoriteMovieIds];
}

class FavoriteMoviesError extends FavoriteMoviesState {
  const FavoriteMoviesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
} 
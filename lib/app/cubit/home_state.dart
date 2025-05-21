import 'package:equatable/equatable.dart';
import 'package:tmdb_flutter/app/api/models/movie_responses.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.trendingMovies,
    required this.popularMovies,
    required this.upcomingMovies,
    required this.genres,
  });

  final MoviesResponse trendingMovies;
  final MoviesResponse popularMovies;
  final MoviesResponse upcomingMovies;
  final GenresResponse genres;

  @override
  List<Object?> get props =>
      [trendingMovies, popularMovies, upcomingMovies, genres];
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

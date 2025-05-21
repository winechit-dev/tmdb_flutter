import 'package:equatable/equatable.dart';
import '../api/models/movie_responses.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MoviesResponse trendingMovies;
  final MoviesResponse popularMovies;
  final MoviesResponse upcomingMovies;
  final GenresResponse genres;

  const HomeLoaded({
    required this.trendingMovies,
    required this.popularMovies,
    required this.upcomingMovies,
    required this.genres,
  });

  @override
  List<Object?> get props => [trendingMovies, popularMovies, upcomingMovies, genres];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
} 
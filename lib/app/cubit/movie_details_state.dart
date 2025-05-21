import 'package:equatable/equatable.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  const MovieDetailsLoaded({
    required this.movieDetails,
    required this.credits,
  });

  final MovieDetailsResponse movieDetails;
  final CreditsResponse credits;

  @override
  List<Object?> get props => [movieDetails, credits];
}

class MovieDetailsError extends MovieDetailsState {
  const MovieDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
} 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/data/repository/movies_repository.dart';
import 'package:tmdb_flutter/app/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(HomeInitial());
  final MoviesRepository _repository;

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());

      final trendingMovies = await _repository.getTrendingTodayMovies();
      final popularMovies = await _repository.getPopularMovies();
      final upcomingMovies = await _repository.getUpcomingMovies();
      final genres = await _repository.getMovieGenres();

      emit(
        HomeLoaded(
          trendingMovies: trendingMovies,
          popularMovies: popularMovies,
          upcomingMovies: upcomingMovies,
          genres: genres,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}

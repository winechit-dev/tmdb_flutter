import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/api/movie_api.dart';
import 'package:tmdb_flutter/app/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._movieAPI) : super(HomeInitial());
  final MovieAPI _movieAPI;

  Future<void> loadHomeData() async {
    try {
      emit(HomeLoading());

      final trendingMovies = await _movieAPI.getTrendingTodayMovies();
      final popularMovies = await _movieAPI.getPopularMovies();
      final upcomingMovies = await _movieAPI.getUpcomingMovies();
      final genres = await _movieAPI.getMovieGenres();

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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/data/repository/movies_repository.dart';
import 'package:tmdb_flutter/app/cubit/home_state.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(HomeInitial());
  final MoviesRepository _repository;

  MoviesRepository get repository => _repository;

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
          selectedGenreId: null,
          filteredTrending: trendingMovies.results,
          filteredPopular: popularMovies.results,
          filteredUpcoming: upcomingMovies.results,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void selectGenre(int? genreId) {
    if (state is HomeLoaded) {
      final loaded = state as HomeLoaded;
      List<Movie> filter(List<Movie> movies) => genreId == null
          ? movies
          : movies
              .where((m) => m.genreIds?.contains(genreId) ?? false)
              .toList();
      emit(HomeLoaded(
        trendingMovies: loaded.trendingMovies,
        popularMovies: loaded.popularMovies,
        upcomingMovies: loaded.upcomingMovies,
        genres: loaded.genres,
        selectedGenreId: genreId,
        filteredTrending: filter(loaded.trendingMovies.results),
        filteredPopular: filter(loaded.popularMovies.results),
        filteredUpcoming: filter(loaded.upcomingMovies.results),
      ));
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}

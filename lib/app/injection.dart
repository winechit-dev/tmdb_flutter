import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_cubit.dart';
import 'package:tmdb_flutter/app/data/local/database_helper.dart';
import 'package:tmdb_flutter/app/data/local/favorite_movies_local_data_source.dart';
import 'package:tmdb_flutter/app/data/remote/movie_api.dart';
import 'package:tmdb_flutter/app/data/repository/movies_repository.dart';
import 'package:tmdb_flutter/app/cubit/movie_details_cubit.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register singletons
  getIt
    ..registerSingleton<DatabaseHelper>(DatabaseHelper())
    ..registerSingleton<MovieAPI>(MovieAPI())

    // Register factories
    ..registerFactory<FavoriteMoviesLocalDataSource>(
      () => FavoriteMoviesLocalDataSource(getIt<DatabaseHelper>()),
    )
    ..registerFactory<MoviesRepository>(
      () => MoviesRepository(
        getIt<FavoriteMoviesLocalDataSource>(),
        getIt<MovieAPI>(),
      ),
    )
    ..registerFactory<HomeCubit>(
      () => HomeCubit(getIt<MoviesRepository>()),
    )
    ..registerFactory<FavoriteMoviesCubit>(
      () => FavoriteMoviesCubit(getIt<MoviesRepository>()),
    )
    ..registerFactory(() => MovieDetailsCubit(getIt()));
}

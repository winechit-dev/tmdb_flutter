import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/api/movie_api.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_cubit.dart';
import 'package:tmdb_flutter/app/data/local/database_helper.dart';
import 'package:tmdb_flutter/app/data/local/favorite_movies_local_data_source.dart';
import 'package:tmdb_flutter/app/data/repository/favorite_movies_repository.dart';
import 'package:tmdb_flutter/app/view/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(MovieAPI()),
        ),
        BlocProvider(
          create: (context) => FavoriteMoviesCubit(
            FavoriteMoviesRepository(
              FavoriteMoviesLocalDataSource(DatabaseHelper()),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'TMDB Movies',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainPage(),
      ),
    );
  }
}

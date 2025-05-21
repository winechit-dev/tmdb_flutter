import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_cubit.dart';
import 'package:tmdb_flutter/app/cubit/movie_details_cubit.dart';
import 'package:tmdb_flutter/app/injection.dart';
import 'package:tmdb_flutter/app/view/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<HomeCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<FavoriteMoviesCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<MovieDetailsCubit>(),
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

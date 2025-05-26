import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_state.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';
import 'package:tmdb_flutter/app/view/details_page.dart';
import 'package:tmdb_flutter/app/view/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            context.read<HomeCubit>().loadHomeData();
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().refreshHomeData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome,',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Millions of movies, TV shows and people to discover. Explore now.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Colors.black54),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black54),
                          filled: true,
                          fillColor: const Color(0xFFE7E2EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(color: Colors.black),
                        readOnly: true,
                        onTap: () {
                          final repository =
                              context.read<HomeCubit>().repository;
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  SearchPage(repository: repository),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.genres.genres.length,
                          itemBuilder: (context, index) {
                            final genre = state.genres.genres[index];
                            return _CategoryChip(
                              label: genre.name,
                              selected: index == 0,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Today Trending',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.trendingMovies.results.length,
                          itemBuilder: (context, index) {
                            final movie = state.trendingMovies.results[index];
                            return _MovieCard(
                              movie: movie,
                              borderColor: const Color(0xFFF9D949),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Popular',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.popularMovies.results.length,
                          itemBuilder: (context, index) {
                            final movie = state.popularMovies.results[index];
                            return _MovieCard(
                              movie: movie,
                              small: true,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Upcoming',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.upcomingMovies.results.length,
                          itemBuilder: (context, index) {
                            final movie = state.upcomingMovies.results[index];
                            return _MovieCard(
                              movie: movie,
                              small: true,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.pinkAccent,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        side: BorderSide(
          color: selected ? Colors.pinkAccent : Colors.black26,
        ),
        onSelected: (_) {},
      ),
    );
  }
}

class _MovieCard extends StatefulWidget {
  const _MovieCard({
    required this.movie,
    this.small = false,
    this.borderColor,
  });

  final Movie movie;
  final bool small;
  final Color? borderColor;

  @override
  State<_MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<_MovieCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final cubit = context.read<FavoriteMoviesCubit>();
    final isFavorite = await cubit.isMovieFavorite(widget.movie.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => DetailsPage(movie: widget.movie),
          ),
        );
      },
      child: Container(
        width: widget.small ? 120 : 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: widget.borderColor != null
              ? Border.all(color: widget.borderColor!, width: 2)
              : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                    height: widget.small ? 180 : 320,
                    width: widget.small ? 120 : 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: widget.small ? 180 : 320,
                        width: widget.small ? 120 : 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error_outline),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () async {
                  await context
                      .read<FavoriteMoviesCubit>()
                      .toggleFavorite(widget.movie);
                  await _checkFavoriteStatus();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

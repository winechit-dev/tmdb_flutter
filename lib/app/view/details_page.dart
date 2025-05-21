import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';
import 'package:tmdb_flutter/app/cubit/movie_details_cubit.dart';
import 'package:tmdb_flutter/app/cubit/movie_details_state.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({required this.movie, super.key});

  final Movie movie;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    context.read<MovieDetailsCubit>().loadMovieDetails(widget.movie.id);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MovieDetailsCubit>()
                          .loadMovieDetails(widget.movie.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final movieDetails =
              state is MovieDetailsLoaded ? state.movieDetails : null;
          final credits = state is MovieDetailsLoaded ? state.credits : null;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath ?? widget.movie.posterPath}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: _CircleButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: _CircleButton(
                          icon: _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          onTap: () async {
                            await context
                                .read<FavoriteMoviesCubit>()
                                .toggleFavorite(widget.movie);
                            await _checkFavoriteStatus();
                          },
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 0,
                        child: _RatingIndicator(
                          percent: widget.movie.voteAverage / 10,
                        ),
                      ),
                      Positioned(
                        left: 100,
                        bottom: 32,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (movieDetails != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                movieDetails.genres
                                    .map((g) => g.name)
                                    .join(', '),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.movie.overview,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (movieDetails != null) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            '${movieDetails.runtime} min',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            movieDetails.releaseDate ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (credits != null) ...[
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Cast',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: credits.cast.length,
                        itemBuilder: (context, index) {
                          final cast = credits.cast[index];
                          return _CastCard(
                            name: cast.name,
                            image: cast.profilePath != null
                                ? 'https://image.tmdb.org/t/p/w200${cast.profilePath}'
                                : 'https://via.placeholder.com/200x300?text=No+Image',
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

class _RatingIndicator extends StatelessWidget {
  const _RatingIndicator({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
          Center(
            child: CircularProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          Center(
            child: Text(
              (percent * 10).toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({
    required this.name,
    required this.image,
  });

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error_outline),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_cubit.dart';
import 'package:tmdb_flutter/app/cubit/home_state.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';
import 'package:tmdb_flutter/app/view/details_page.dart';
import 'package:tmdb_flutter/app/view/search_page.dart';
import 'package:tmdb_flutter/app/widgets/language_switcher.dart';
import 'package:tmdb_flutter/app/widgets/shimmer_loading.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).welcome,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.zero,
            child: LanguageSwitcher(),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            context.read<HomeCubit>().loadHomeData();
            return const _ShimmerHomePlaceholder();
          }

          if (state is HomeLoading) {
            return const _ShimmerHomePlaceholder();
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
                    child: Text(AppLocalizations.of(context).retry),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            final genres = state.genres.genres;
            final selectedGenreId = state.selectedGenreId;

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refreshHomeData(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context).welcomeDescription,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).search,
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
                          itemCount: genres.length,
                          itemBuilder: (context, index) {
                            final genre = genres[index];
                            return _CategoryChip(
                              label: genre.name,
                              selected: genre.id == selectedGenreId,
                              onSelected: (selected) {
                                if (selected) {
                                  context
                                      .read<HomeCubit>()
                                      .selectGenre(genre.id);
                                } else {
                                  context.read<HomeCubit>().selectGenre(null);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      if (state.filteredTrending.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context).todayTrending,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.filteredTrending.length,
                            itemBuilder: (context, index) {
                              final movie = state.filteredTrending[index];
                              return _MovieCard(
                                movie: movie,
                                borderColor: const Color(0xFFF9D949),
                              );
                            },
                          ),
                        ),
                      ],
                      if (state.filteredPopular.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context).popular,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.filteredPopular.length,
                            itemBuilder: (context, index) {
                              final movie = state.filteredPopular[index];
                              return _MovieCard(
                                movie: movie,
                              );
                            },
                          ),
                        ),
                      ],
                      if (state.filteredUpcoming.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          AppLocalizations.of(context).upcoming,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.filteredUpcoming.length,
                            itemBuilder: (context, index) {
                              final movie = state.filteredUpcoming[index];
                              return _MovieCard(
                                movie: movie,
                              );
                            },
                          ),
                        ),
                      ],
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
  const _CategoryChip(
      {required this.label, this.selected = false, this.onSelected});

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

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
        onSelected: onSelected,
      ),
    );
  }
}

class _MovieCard extends StatefulWidget {
  const _MovieCard({
    required this.movie,
    this.borderColor,
  });

  final Movie movie;
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
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => DetailsPage(movie: widget.movie),
            ),
          );
        },
        child: SizedBox(
          width: 120,
          child: Stack(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                height: 180,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error_outline, size: 40),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    width: 120,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
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
                      color: Colors.white.withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.black54,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerHomePlaceholder extends StatelessWidget {
  const _ShimmerHomePlaceholder();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const ShimmerLoading(height: 20, width: 200),
            const SizedBox(height: 16),
            const ShimmerLoading(height: 36),
            const SizedBox(height: 24),
            const ShimmerLoading(height: 20, width: 150),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: ShimmerLoading(
                      height: 180,
                      width: 120,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const ShimmerLoading(height: 20, width: 100),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: ShimmerLoading(
                        height: 180,
                        width: 120,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const ShimmerLoading(height: 20, width: 100),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: ShimmerLoading(
                      height: 180,
                      width: 120,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

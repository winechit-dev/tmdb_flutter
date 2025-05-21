import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/api/models/movie_responses.dart';
import 'package:tmdb_flutter/app/cubit/favorite_movies_cubit.dart';

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
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await context.read<FavoriteMoviesCubit>().isMovieFavorite(widget.movie.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FF),
      body: SafeArea(
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
                      icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                      onTap: () async {
                        await context.read<FavoriteMoviesCubit>().toggleFavorite(widget.movie);
                        _checkFavoriteStatus();
                      },
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 0,
                    child: _RatingIndicator(percent: widget.movie.voteAverage / 10),
                  ),
                  const Positioned(
                    left: 100,
                    bottom: 32,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Legend of Ochi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '-',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'In a remote village on the island of Carpathia, a shy farm girl named Yuri is raised to fear an elusive animal species known as ochi. But when Yuri discovers a wounded baby ochi has been left behind, she escapes on a quest to bring him home.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
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
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _CastCard(
                        name: 'Helena Zengel',
                        image:
                            'https://randomuser.me/api/portraits/women/1.jpg'),
                    _CastCard(
                        name: 'Finn Wolfhard',
                        image: 'https://randomuser.me/api/portraits/men/2.jpg'),
                    _CastCard(
                        name: 'Emily Watson',
                        image:
                            'https://randomuser.me/api/portraits/women/3.jpg'),
                    _CastCard(
                        name: 'Willem Dafoe',
                        image: 'https://randomuser.me/api/portraits/men/4.jpg'),
                    _CastCard(
                        name: 'Razvan Stoica',
                        image: 'https://randomuser.me/api/portraits/men/5.jpg'),
                    _CastCard(
                        name: 'Carol B.',
                        image:
                            'https://randomuser.me/api/portraits/women/6.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _CategoryChip(label: 'Fantasy'),
                    _CategoryChip(label: 'Adventure'),
                    _CategoryChip(label: 'Family'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recommendations',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: const [
                    _RecommendationCard(
                        image: 'https://image.tmdb.org/t/p/w500/rec1.jpg'),
                    _RecommendationCard(
                        image: 'https://image.tmdb.org/t/p/w500/rec2.jpg'),
                    _RecommendationCard(
                        image: 'https://image.tmdb.org/t/p/w500/rec3.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onTap,
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
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
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
              strokeWidth: 4,
            ),
          ),
          Center(
            child: Text(
              '${(percent * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.black,
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
  const _CastCard({required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(image),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      side: const BorderSide(color: Colors.black12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

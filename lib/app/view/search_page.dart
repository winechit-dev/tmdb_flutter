import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';
import 'package:tmdb_flutter/app/data/repository/movies_repository.dart';
import 'package:tmdb_flutter/app/view/details_page.dart';

class SearchCubit extends Cubit<List<Movie>> {
  SearchCubit(this.repository) : super([]);
  final MoviesRepository repository;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit([]);
      return;
    }
    final response = await repository.searchMovie(query: query);
    emit(response.results);
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({required this.repository, super.key});

  final MoviesRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(repository),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F3FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _SearchBar(),
        ),
        body: BlocBuilder<SearchCubit, List<Movie>>(
          builder: (context, movies) {
            if (movies.isEmpty) {
              return const Center(child: Text('No results'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => DetailsPage(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 120,
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.overview.isNotEmpty
                                      ? movie.overview
                                      : '-',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    if (movie is MovieDetailsResponse)
                                      ...movie.genres
                                          .map((g) => Chip(label: Text(g.name)))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search',
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            context.read<SearchCubit>().search('');
          },
        ),
      ),
      onChanged: (query) {
        context.read<SearchCubit>().search(query);
      },
    );
  }
}

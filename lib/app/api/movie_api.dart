import 'package:dio/dio.dart';
import 'package:tmdb_flutter/app/api/models/movie_responses.dart';

class MovieAPI {

  MovieAPI() : _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.queryParameters = {'api_key': _apiKey};
  }
  final Dio _dio;
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '431684f2f57b4a3f0d520afae0ee6a4f';

  static const int STARTING_PAGE_INDEX = 1;
  static const String LANGUAGE = "en-US";

  Future<MoviesResponse> getTrendingTodayMovies({
    int page = STARTING_PAGE_INDEX,
    String language = LANGUAGE,
  }) async {
    try {
      final response = await _dio.get(
        '/trending/movie/day',
        queryParameters: {
          'page': page,
          'language': language,
        },
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load trending movies: $e');
    }
  }

  Future<MoviesResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }

  Future<MoviesResponse> getUpcomingMovies({
    int page = STARTING_PAGE_INDEX,
    String language = LANGUAGE,
  }) async {
    try {
      final response = await _dio.get(
        '/movie/upcoming',
        queryParameters: {
          'page': page,
          'language': language,
        },
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load upcoming movies: $e');
    }
  }

  Future<MoviesResponse> getTopRatedMovies({
    int page = STARTING_PAGE_INDEX,
    String language = LANGUAGE,
  }) async {
    try {
      final response = await _dio.get(
        '/movie/top_rated',
        queryParameters: {
          'page': page,
          'language': language,
        },
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load top rated movies: $e');
    }
  }

  Future<MoviesResponse> getNowPlayingMovies({
    int page = STARTING_PAGE_INDEX,
    String language = LANGUAGE,
  }) async {
    try {
      final response = await _dio.get(
        '/movie/now_playing',
        queryParameters: {
          'page': page,
          'language': language,
        },
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load now playing movies: $e');
    }
  }

  Future<GenresResponse> getMovieGenres({
    String language = LANGUAGE,
  }) async {
    try {
      final response = await _dio.get(
        '/genre/movie/list',
        queryParameters: {
          'language': language,
        },
      );
      return GenresResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load movie genres: $e');
    }
  }

  Future<MovieDetailsResponse> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId');
      return MovieDetailsResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  Future<CreditsResponse> getMovieCredits(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId/credits');
      return CreditsResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load movie credits: $e');
    }
  }

  Future<MoviesResponse> getRecommendations({
    required int movieId,
    int page = STARTING_PAGE_INDEX,
    String language = LANGUAGE,
  }) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/recommendations',
        queryParameters: {
          'page': page,
          'language': language,
        },
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to load movie recommendations: $e');
    }
  }

  Future<MoviesResponse> searchMovie({
    required String query,
    int page = STARTING_PAGE_INDEX,
  }) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
          'page': page,
        },
      );
      return MoviesResponse.fromJson(response.data as Map<String,dynamic>);
    } catch (e) {
      throw Exception('Failed to search for movies: $e');
    }
  }
} 
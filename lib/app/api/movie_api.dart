import 'package:dio/dio.dart';
import 'models/movie_responses.dart';

class MovieApi {
  final Dio _dio;
  static const String _baseUrl = 'https://api.themoviedb.org/3/';

  MovieApi({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
  }

  static const int STARTING_PAGE_INDEX = 1;
  static const String LANGUAGE = "en-US";
  static const String API_KEY = ""; // Replace with your actual API key

  Future<MoviesResponse> getTrendingTodayMovies({
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'trending/movie/day',
      queryParameters: {
        'page': page,
        'api_key': apiKey,
        'language': language,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }

  Future<MoviesResponse> getPopularMovies({
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'movie/popular',
      queryParameters: {
        'page': page,
        'api_key': apiKey,
        'language': language,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }

  Future<MoviesResponse> getUpcomingMovies({
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'movie/upcoming',
      queryParameters: {
        'page': page,
        'api_key': apiKey,
        'language': language,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }

  Future<MoviesResponse> getTopRatedMovies({
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'movie/top_rated',
      queryParameters: {
        'page': page,
        'api_key': apiKey,
        'language': language,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }

  Future<MoviesResponse> getNowPlayingMovies({
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'movie/now_playing',
      queryParameters: {
        'page': page,
        'api_key': apiKey,
        'language': language,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }

  Future<GenresResponse> getMovieGenres({
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'genre/movie/list',
      queryParameters: {
        'api_key': apiKey,
        'language': language,
      },
    );
    return GenresResponse.fromJson(response.data);
  }

  Future<MovieDetailsResponse> getMovieDetails({
    required int movieId,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'movie/$movieId',
      queryParameters: {
        'api_key': apiKey,
        'language': language,
      },
    );
    return MovieDetailsResponse.fromJson(response.data);
  }

  Future<CreditsResponse> getCast({
    required int movieId,
    String apiKey = API_KEY,
  }) async {
    final response = await _dio.get(
      'movie/$movieId/credits',
      queryParameters: {
        'api_key': apiKey,
      },
    );
    return CreditsResponse.fromJson(response.data);
  }

  Future<MoviesResponse> getRecommendations({
    required int movieId,
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
    String language = LANGUAGE,
  }) async {
    final response = await _dio.get(
      'movie/$movieId/recommendations',
      queryParameters: {
        'page': page,
        'api_key': apiKey,
        'language': language,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }

  Future<MoviesResponse> searchMovie({
    required String query,
    int page = STARTING_PAGE_INDEX,
    String apiKey = API_KEY,
  }) async {
    final response = await _dio.get(
      'search/movie',
      queryParameters: {
        'query': query,
        'page': page,
        'api_key': apiKey,
      },
    );
    return MoviesResponse.fromJson(response.data);
  }
} 
import 'package:dio/dio.dart';
import 'package:tmdb_flutter/app/data/remote/models/movie_responses.dart';

class MovieAPI {
  MovieAPI() : _dio = Dio(_createBaseOptions());

  final Dio _dio;
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '431684f2f57b4a3f0d520afae0ee6a4f';

  static const int startingPageIndex = 1;
  static const String defaultLanguage = 'en-US';

  /// Creates base options for Dio instance
  static BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      queryParameters: {'api_key': _apiKey},
      validateStatus: (status) => status != null && status < 500,
    );
  }

  /// Generic method to handle GET requests
  Future<T> _get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.request<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200 && response.data != null) {
        return fromJson != null ? fromJson(response.data!) : response.data as T;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Invalid response: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw Exception('API request failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<MoviesResponse> getTrendingTodayMovies({
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/trending/movie/day',
      queryParameters: {
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  Future<MoviesResponse> getPopularMovies({
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/movie/popular',
      queryParameters: {
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  Future<MoviesResponse> getUpcomingMovies({
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/movie/upcoming',
      queryParameters: {
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  Future<MoviesResponse> getTopRatedMovies({
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/movie/top_rated',
      queryParameters: {
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  Future<MoviesResponse> getNowPlayingMovies({
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/movie/now_playing',
      queryParameters: {
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  Future<GenresResponse> getMovieGenres({
    String language = defaultLanguage,
  }) async {
    return _get(
      '/genre/movie/list',
      queryParameters: {'language': language},
      fromJson: GenresResponse.fromJson,
    );
  }

  Future<MovieDetailsResponse> getMovieDetails(int movieId) async {
    return _get(
      '/movie/$movieId',
      fromJson: MovieDetailsResponse.fromJson,
    );
  }

  Future<CreditsResponse> getMovieCredits(int movieId) async {
    return _get(
      '/movie/$movieId/credits',
      fromJson: CreditsResponse.fromJson,
    );
  }

  Future<MoviesResponse> getRecommendations({
    required int movieId,
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/movie/$movieId/recommendations',
      queryParameters: {
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  Future<MoviesResponse> searchMovie({
    required String query,
    int page = startingPageIndex,
    String language = defaultLanguage,
  }) async {
    return _get(
      '/search/movie',
      queryParameters: {
        'query': query,
        'page': page,
        'language': language,
      },
      fromJson: MoviesResponse.fromJson,
    );
  }

  /// Closes the Dio client and cleans up resources
  void dispose() {
    _dio.close();
  }
}

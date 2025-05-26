import 'package:json_annotation/json_annotation.dart';

part 'movie_responses.g.dart';

@JsonSerializable()
class MoviesResponse {
  MoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);
}

@JsonSerializable()
class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  final String overview;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class MovieDetailsResponse extends Movie {
  MovieDetailsResponse({
    required super.id,
    required super.title,
    required super.voteAverage,
    required super.overview,
    required this.genres,
    required this.runtime,
    required this.productionCompanies,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseFromJson(json);
  final List<Genre> genres;
  final int runtime;
  @JsonKey(name: 'production_companies')
  final List<ProductionCompany> productionCompanies;

  @override
  Map<String, dynamic> toJson() => _$MovieDetailsResponseToJson(this);
}

@JsonSerializable()
class Genre {
  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  final int id;
  final String name;

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class ProductionCompany {
  ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);
  final int id;
  final String name;
  @JsonKey(name: 'logo_path')
  final String? logoPath;
  @JsonKey(name: 'origin_country')
  final String originCountry;

  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable()
class GenresResponse {
  GenresResponse({required this.genres});

  factory GenresResponse.fromJson(Map<String, dynamic> json) =>
      _$GenresResponseFromJson(json);
  final List<Genre> genres;

  Map<String, dynamic> toJson() => _$GenresResponseToJson(this);
}

@JsonSerializable()
class CreditsResponse {
  CreditsResponse({required this.cast, required this.crew});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreditsResponseFromJson(json);
  final List<Cast> cast;
  final List<Crew> crew;

  Map<String, dynamic> toJson() => _$CreditsResponseToJson(this);
}

@JsonSerializable()
class Cast {
  Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
  final int id;
  final String name;
  final String character;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@JsonSerializable()
class Crew {
  Crew({
    required this.id,
    required this.name,
    required this.department,
    required this.job,
    this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
  final int id;
  final String name;
  final String department;
  final String job;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  Map<String, dynamic> toJson() => _$CrewToJson(this);
}

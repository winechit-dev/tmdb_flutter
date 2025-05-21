import 'package:json_annotation/json_annotation.dart';

part 'movie_responses.g.dart';

@JsonSerializable()
class MoviesResponse {
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);
}

@JsonSerializable()
class Movie {
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

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.voteAverage,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class MovieDetailsResponse extends Movie {
  final List<Genre> genres;
  final int runtime;
  @JsonKey(name: 'production_companies')
  final List<ProductionCompany> productionCompanies;

  MovieDetailsResponse({
    required super.id,
    required super.title,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    required super.voteAverage,
    required super.overview,
    required this.genres,
    required this.runtime,
    required this.productionCompanies,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MovieDetailsResponseToJson(this);
}

@JsonSerializable()
class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class ProductionCompany {
  final int id;
  final String name;
  @JsonKey(name: 'logo_path')
  final String? logoPath;
  @JsonKey(name: 'origin_country')
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionCompanyToJson(this);
}

@JsonSerializable()
class GenresResponse {
  final List<Genre> genres;

  GenresResponse({required this.genres});

  factory GenresResponse.fromJson(Map<String, dynamic> json) =>
      _$GenresResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenresResponseToJson(this);
}

@JsonSerializable()
class CreditsResponse {
  final List<Cast> cast;
  final List<Crew> crew;

  CreditsResponse({required this.cast, required this.crew});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreditsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsResponseToJson(this);
}

@JsonSerializable()
class Cast {
  final int id;
  final String name;
  final String character;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@JsonSerializable()
class Crew {
  final int id;
  final String name;
  final String department;
  final String job;
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  Crew({
    required this.id,
    required this.name,
    required this.department,
    required this.job,
    this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  Map<String, dynamic> toJson() => _$CrewToJson(this);
} 
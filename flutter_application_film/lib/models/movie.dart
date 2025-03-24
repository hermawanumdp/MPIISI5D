class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;

  Movie(
      {required this.id,
      required this.title,
      required this.overview,
      required this.posterPath,
      required this.backdropPath,
      required this.releaseDate,
      required this.voteAverage});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json["id"],
        title: json["title"],
        overview: json["overview"],
        posterPath: json["poster_path"] ?? '',
        backdropPath: json["backdrop_path"] ?? '',
        releaseDate: json["release_date"],
        voteAverage: json["vote_average"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage
    };
  }
}

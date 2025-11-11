class Movie {
  final String title;
  final String director;
  final int year;
  final String poster;

  Movie({
    required this.title,
    required this.director,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      director: json['director'],
      year: json['year'],
      poster: json['poster'],
    );
  }
}

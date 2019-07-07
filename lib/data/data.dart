
import 'package:flutter_app/data/movie.dart';

class Data {
  int page;
  int totalPages;
  List<Movie> movies;
  Data({this.page, this.totalPages, this.movies});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        page: json['page'],
        totalPages: json['total_pages'],
        movies: (json['results'] as List).map((i) => new
        Movie.fromJson(i)).toList());
  }
}
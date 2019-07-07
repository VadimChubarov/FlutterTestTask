import 'package:flutter_app/data/data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoviesNetwork extends NetworkRepository {

  static final NetworkRepository networkRepository = new MoviesNetwork();
  final String apiKey = "75e81fdfe4885449c794f75f5e80f23c";
  final String baseUrl = "https://api.themoviedb.org/3/";
  final String getPopularMoviesPath = "movie/popular";
  final String keyParam = "?api_key=";
  final String pageParam = "&page=";

  static NetworkRepository getInstance(){
    return  networkRepository;
  }
  @override
  Future<Data> getPopularMovies(int page) async {
    final response = await http.get(
        baseUrl +
            getPopularMoviesPath +
            keyParam + apiKey +
            pageParam + page.toString());

    if (response.statusCode == 200) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

abstract class NetworkRepository {
  Future<Data> getPopularMovies(int page);
}

enum DataLoadMoreStatus { LOADING, STABLE }
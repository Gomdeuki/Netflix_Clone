// import 'package:flutter/material.dart';
// import 'dart:math';

import 'dart:convert';
import 'dart:developer';

import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_datailed_model.dart';
import 'package:netflix_clone/models/movie_recommendation_model.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
//import 'package:netflix_clone/models/nowplaying_model.dart';
import 'package:netflix_clone/models/upcoming_model.dart';
import 'package:http/http.dart' as http;
import 'package:netflix_clone/models/search_model.dart';

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movie");
  }


  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load now playing movie");
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = "tv/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load top rated tv series");
  }


  Future<MovieRecommendationModel> getPopularMovies() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load popular movies");
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    endPoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endPoint";
    print("search url is $url");
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzcyODAyNzAyNDQ0ZDU1NDJhMWFiZTY3MGNjMjY0MyIsIm5iZiI6MTcyODAzMjQ1Ny45MTI0NjksInN1YiI6IjY2ZjY3M2E2YjlkNjdhYWRlYzUwYTRmMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7MGnmK1Qezm4wkB0-JeO1LAnVL-iCv7YQqpDL8fvJ5w"
    });

    if (response.statusCode == 200) {
      log("Success");

      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load searched movie");
  }

Future<MovieDetailedModel> getMovieDetail(int movieId) async {
    endPoint = "movie/$movieId";
    final url = "$baseUrl$endPoint$key";
    print("movie details url is $url");
    final response = await http.get(
      Uri.parse(url),
     );

    if (response.statusCode == 200) {
      log("Success");

      return MovieDetailedModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movie details");
  }

Future<MovieRecommendationModel> getMovieRecommendations(int movieId) async {
    endPoint = "movie/$movieId/recommendations";
    final url = "$baseUrl$endPoint$key";
    print("recommendations url is $url");
    final response = await http.get(
      Uri.parse(url),
     );

    if (response.statusCode == 200) {
      log("Success");
      log(response.body);

      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load more like this");
  }
  
  
}

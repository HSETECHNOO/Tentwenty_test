// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_import, avoid_print

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:retry/retry.dart';
import 'package:tentwenty_test/app/core/configs/api_configs.dart';
import 'package:tentwenty_test/app/core/services/cache_images.dart';
import 'package:tentwenty_test/app/core/services/service_locator.dart';
import 'package:tentwenty_test/app/core/utils/api_exceptions.dart';
import 'package:tentwenty_test/app/core/utils/logger.dart';
import 'package:tentwenty_test/app/database/movies_database.dart';
import 'package:tentwenty_test/app/database/repositories/movies_repository.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';

class UpcomingMoviesApiService {
  final http.Client _client;
  UpcomingMoviesApiService({http.Client? client})
      : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  final MoviesRepository _moviesRepository = database.moviesRepository;
  Future<MovieResponse> fetchUpcomingMovies() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final movies = await _moviesRepository.fetchMovies();
        if (movies.isNotEmpty) {
          AppLogger.info('fetched from offline');
          return MovieResponse(results: movies, page: 0);
        } else {
          throw ApiException('No internet connection');
        }
      }
      final response = await retry(
        () => _makeRequest(),
        retryIf: ApiConfig.shouldRetry,
        maxAttempts: ApiConfig.maxRetries,
        delayFactor: ApiConfig.retryDelay,
      );
      final data = json.decode(response.body);
      MovieResponse moviesUpcoming = MovieResponse.fromJson(data);
      _moviesRepository.insertMovies(moviesUpcoming.results!);
      final posterPaths = moviesUpcoming.results
          ?.map((movie) => movie.backdropPath.toString())
          .toList();
      await prefetchMovieImages(posterPaths ?? []);
      return moviesUpcoming;
    } on TimeoutException {
      throw ApiException('Request timed out');
    } on SocketException {
      throw ApiException('No internet connection');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<http.Response> _makeRequest() async {
    Map<String, String> _headers = {'Content-Type': 'application/json'};
    final response = await _client
        .get(
            Uri.parse(
                'https://api.themoviedb.org/3/movie/upcoming?api_key=6951d331ef632f847286083120626d1a'),
            headers: _headers)
        .timeout(ApiConfig.timeout);
    ApiConfig.validateResponse(response);
    return response;
  }
}

// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_import

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
import 'package:tentwenty_test/app/database/details_database.dart';
import 'package:tentwenty_test/app/database/repositories/movies_detail_repository.dart';
import 'package:tentwenty_test/app/database/tentwenty_database.dart';
import 'package:tentwenty_test/app/models/movies_details.dart';

class MoviesDetailsApiService {
  final http.Client _client;
  MoviesDetailsApiService({http.Client? client})
      : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  final MoviesDetailRepository _moviesRepository =
      database.moviesDetailRepository;
  Future<MovieDetailsModel> fetchMovieDetails(int movieid) async {
    try {
      AppLogger.info(movieid.toString());
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        final fetchedMovieResponse =
            await _moviesRepository.getMovieDetails(movieid);
        if (fetchedMovieResponse.isNotEmpty) {
          return MovieDetailsModel(
              overview: fetchedMovieResponse.first.overview,
              genres: fetchedMovieResponse.first.genre,
              title: fetchedMovieResponse.first.title,
              backdropPath: fetchedMovieResponse.first.backdropPath,
              id: fetchedMovieResponse.first.id);
        } else {
          throw ApiException(
              'No internet connection && No data saved Locally Found');
        }
      }
      final response = await retry(
        () => _makeRequest(movieid),
        retryIf: ApiConfig.shouldRetry,
        maxAttempts: ApiConfig.maxRetries,
        delayFactor: ApiConfig.retryDelay,
      );

      final data = json.decode(response.body);
      AppLogger.info(response.body);
      MovieDetailsModel movieDetailsModel = MovieDetailsModel.fromJson(data);
      final fetchedMovieResponse =
          await _moviesRepository.getMovieDetails(movieid);
      if (fetchedMovieResponse.isEmpty) {
        await _moviesRepository.insertMovieDetails(MovieDetail(
            id: movieDetailsModel.id,
            backdropPath: movieDetailsModel.backdropPath,
            overview: movieDetailsModel.overview,
            title: movieDetailsModel.title,
            genre: movieDetailsModel.genres));
      }

      await prefetchMovieImage(movieDetailsModel.backdropPath ?? '');
      return movieDetailsModel;
    } on TimeoutException {
      throw ApiException('Request timed out');
    } on SocketException {
      throw ApiException('No internet connection, please Try again');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<http.Response> _makeRequest(int movieid) async {
    Map<String, String> _headers = {'Content-Type': 'application/json'};
    final response = await _client
        .get(
            Uri.parse(
                'https://api.themoviedb.org/3/movie/$movieid?api_key=6951d331ef632f847286083120626d1a'),
            headers: _headers)
        .timeout(ApiConfig.timeout);
    ApiConfig.validateResponse(response);
    return response;
  }
}

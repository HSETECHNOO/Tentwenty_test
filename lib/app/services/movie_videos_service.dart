// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_import

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:retry/retry.dart';
import 'package:tentwenty_test/app/core/configs/api_configs.dart';
import 'package:tentwenty_test/app/core/services/service_locator.dart';
import 'package:tentwenty_test/app/core/utils/api_exceptions.dart';
import 'package:tentwenty_test/app/core/utils/logger.dart';
import 'package:tentwenty_test/app/database/movie_videos_database.dart';
import 'package:tentwenty_test/app/database/repositories/movie_videos_repository.dart';
import 'package:tentwenty_test/app/models/movie_videos.dart';

class MoviesVideosApiService {
  final http.Client _client;
  MoviesVideosApiService({http.Client? client})
      : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<MovieVideosModel> fetchMovieVideos(int movieid) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw ApiException(
            'No internet connection && No data saved Locally Found');
      }
      final response = await retry(
        () => _makeRequest(movieid),
        retryIf: ApiConfig.shouldRetry,
        maxAttempts: ApiConfig.maxRetries,
        delayFactor: ApiConfig.retryDelay,
      );
      final data = json.decode(response.body);
      MovieVideosModel movieDetailsModel = MovieVideosModel.fromJson(data);

      return movieDetailsModel;
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

  Future<http.Response> _makeRequest(int movieid) async {
    Map<String, String> _headers = {'Content-Type': 'application/json'};
    final response = await _client
        .get(
            Uri.parse(
                'https://api.themoviedb.org/3/movie/$movieid/videos?api_key=6951d331ef632f847286083120626d1a'),
            headers: _headers)
        .timeout(ApiConfig.timeout);
    ApiConfig.validateResponse(response);
    return response;
  }
}

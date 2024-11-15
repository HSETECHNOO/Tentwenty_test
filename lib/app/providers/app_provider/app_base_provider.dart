import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/core/utils/api_exceptions.dart';
import 'package:tentwenty_test/app/core/utils/logger.dart';
import 'package:tentwenty_test/app/services/upcoming_movies_service.dart';

class AppBaseProvider extends ChangeNotifier {
  final UpcomingMoviesApiService _moviesApiService;
  MovieResponse moviesUpcoming = MovieResponse();
  bool _isLoading = false;
  String? _errorMessage;

  AppBaseProvider({UpcomingMoviesApiService? moviesApiService})
      : _moviesApiService = moviesApiService ?? UpcomingMoviesApiService();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<AppBaseProvider> onInit() async {
    await fetchUpcomingMovies();
    return this;
  }

  Future<void> initializeApp() async {
    try {
      await fetchUpcomingMovies();
    } catch (e) {
      _setError('Failed to load movies: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchUpcomingMovies() async {
    _setLoading(true);
    _setError(null);

    try {
      MovieResponse response = await _moviesApiService.fetchUpcomingMovies();
      _updateMovies(response);
      AppLogger.info(
          "Fetched ${response.results?.length ?? 0} upcoming movies.");
    } on ApiException catch (e) {
      _setError(e.message);
      AppLogger.error('API error: ${e.message}');
    } catch (e) {
      _setError('Unexpected error occurred');
      AppLogger.error('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _updateMovies(MovieResponse response) {
    moviesUpcoming = response;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _moviesApiService.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';

class HomeProvider extends ChangeNotifier {
  bool _isSearching = false;
  final TextEditingController searchController = TextEditingController();
  bool get isSearching => _isSearching;

  update() {
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void closeSearch() {
    _isSearching = false;
    notifyListeners();
  }

  List<MovieModel> filterMoviesByName(List<MovieModel> movies, String name) {
    return movies
        .where((movie) =>
            movie.title.toString().toLowerCase().contains(name.toLowerCase()))
        .toList();
  }
}

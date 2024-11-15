import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/modules/home/widgets/movies_itemcard.dart';
import 'package:tentwenty_test/app/modules/home/widgets/movies_search_card.dart';
import 'package:tentwenty_test/app/providers/app_provider/app_base_provider.dart';
import 'package:tentwenty_test/app/providers/home_provider/home_provider.dart';

class MoviesListView extends StatelessWidget {
  const MoviesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final fetchedMovies = context.select<AppBaseProvider, List<MovieModel>>(
        (provider) => provider.moviesUpcoming.results ?? []);
    return Consumer<HomeProvider>(
      builder: (context, searchProvider, child) {
        final movies = searchProvider.filterMoviesByName(
            fetchedMovies, searchProvider.searchController.text);
        if (movies.isEmpty) {
          return const Center(
            child: Text('No Search Key Movies Found'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return searchProvider.isSearching
                ? MovieItemSearchCard(movieDetails: movie)
                : MovieItemCardMain(
                    movieDetails: movie,
                  );
          },
        );
      },
    );
  }
}

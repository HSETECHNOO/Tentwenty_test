// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tentwenty_test/app/commons/error_message_widget.dart';
import 'package:tentwenty_test/app/core/services/cache_images.dart';
import 'package:tentwenty_test/app/core/utils/api_exceptions.dart';
import 'package:tentwenty_test/app/core/utils/navigations.dart';
import 'package:tentwenty_test/app/models/movies_details.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/modules/home/widgets/movies_itemcard.dart';
import 'package:tentwenty_test/app/modules/home/widgets/videos.dart';
import 'package:tentwenty_test/app/modules/seats_selection/seats_bookings.dart';
import 'package:tentwenty_test/app/services/movies_details_service.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movieDetails;
  MovieDetailsScreen({super.key, required this.movieDetails});
  final ValueNotifier<int> _refreshKey = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    int movieid = movieDetails.id!;
    return Scaffold(
      body: ValueListenableBuilder<int>(
          valueListenable: _refreshKey,
          builder: (context, value, _) {
            return FutureBuilder(
              future: MoviesDetailsApiService().fetchMovieDetails(movieid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _handleError(snapshot, context);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingIndicator();
                }
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                return _buildMovieDetails(snapshot);
              },
            );
          }),
    );
  }

  Widget _handleError(AsyncSnapshot snapshot, BuildContext context) {
    if (snapshot.error is ApiException) {
      return _buildErrorWidget(snapshot, context);
    }
    return Center(
      child: Text(
        snapshot.error.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMovieDetails(AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMovieImageAndOverview(snapshot),
          _buildGenreOverview(snapshot),
        ],
      ),
    );
  }

  Widget _buildMovieImageAndOverview(AsyncSnapshot snapshot) {
    return Stack(
      children: [
        MovieImagePosterWidegt(details: snapshot.data!),
        MovieOverviewWidget(movieDetails: movieDetails),
      ],
    );
  }

  Widget _buildGenreOverview(AsyncSnapshot snapshot) {
    return GenereOverview(details: snapshot.data!);
  }

  Widget _buildErrorWidget(AsyncSnapshot snapshot, BuildContext context) {
    final errorMessage = (snapshot.error as ApiException).message.toString();
    return SafeArea(
      child: Column(
        children: [
          _buildBackButton(context),
          Expanded(
            child: ErrorMessageWidget(
              message: errorMessage,
              onRetry: () {
                _refreshKey.value++;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}

class MovieImagePosterWidegt extends StatelessWidget {
  const MovieImagePosterWidegt({super.key, required this.details});
  final MovieDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: details.title.toString(),
      child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
                Colors.black,
              ],
              stops: const [0.3, 0.7, 1.0],
            ),
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: CachedNetworkImage(
            cacheManager: PersistentCacheManager(),
            imageUrl: buildImageUrl(details.backdropPath.toString()),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, color: Colors.red),
            fit: BoxFit.cover,
          )),
    );
  }
}

class MovieOverviewWidget extends StatelessWidget {
  const MovieOverviewWidget({super.key, required this.movieDetails});
  final MovieModel movieDetails;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  movieDetails.title.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "In Theaters ${movieDetails.releaseDate.toString()}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () {
                      navigateToNextSelection(
                        context,
                        MovieVideoScreen(movieDetails: movieDetails),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Watch Trailer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        navigateToNextSelection(context,
                            SeatsBookingScreen(movieDetails: movieDetails));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Get Tickets',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GenereOverview extends StatelessWidget {
  const GenereOverview({super.key, required this.details});
  final MovieDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genres',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: details.genres!.map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  genre.name.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Divider(
            color: Colors.grey.shade300,
          ),

          // Overview Section
          const SizedBox(height: 12),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            details.overview.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

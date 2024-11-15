// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tentwenty_test/app/core/services/cache_images.dart';

import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/modules/home/widgets/movie_details_screen.dart';

class MovieItemCardMain extends StatelessWidget {
  final MovieModel movieDetails;
  const MovieItemCardMain({
    super.key,
    required this.movieDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            _buildImage(context),
            _buildTitleOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return InkWell(
      onTap: () {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(
                movieDetails: movieDetails,
              ),
            ),
          );
        });
      },
      child: Hero(
        tag: movieDetails.title.toString(),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: movieDetails.backdropPath != null
              ? CachedNetworkImage(
                  cacheManager: PersistentCacheManager(),
                  imageUrl:
                      buildImageUrl(movieDetails.backdropPath.toString()),
                  placeholder: (context, url) => _buildShimmer(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, color: Colors.red),
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.movie, color: Colors.grey),
        ),
      ),
    );
  }



  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 180,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTitleOverlay(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          movieDetails.title.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black45,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
  String buildImageUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
  }
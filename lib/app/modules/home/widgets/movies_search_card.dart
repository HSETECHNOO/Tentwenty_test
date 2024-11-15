// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tentwenty_test/app/core/services/cache_images.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';
import 'package:tentwenty_test/app/modules/home/widgets/movie_details_screen.dart';

class MovieItemSearchCard extends StatelessWidget {
  final MovieModel movieDetails;
  const MovieItemSearchCard({super.key, required this.movieDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: InkWell(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _buildImage(context),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(flex: 8, child: _buildTitleAndGenre(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: movieDetails.title.toString(),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: movieDetails.backdropPath != null
            ? CachedNetworkImage(
                cacheManager: PersistentCacheManager(),
                imageUrl: _buildImageUrl(movieDetails.backdropPath.toString()),
                placeholder: (context, url) => _buildShimmer(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.red),
                fit: BoxFit.cover,
              )
            : const Icon(Icons.movie, color: Colors.grey),
      ),
    );
  }

  String _buildImageUrl(String path) {
    return 'https://image.tmdb.org/t/p/w500$path';
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

  Widget _buildTitleAndGenre(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movieDetails.title.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4.0),
              const Text(
                "Genre",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ],
    );
  }
}

import 'package:drift/drift.dart';
import 'package:tentwenty_test/app/database/tables/movie_videos/movie_videos.dart';

import 'package:tentwenty_test/app/database/tentwenty_database.dart';
import 'package:tentwenty_test/app/models/movie_videos.dart';

part 'movie_videos_repository.g.dart';

@DriftAccessor(tables: [MovieVideos])
class MoviesVideosRepository extends DatabaseAccessor<TestDatabase>
    with _$MoviesVideosRepositoryMixin {
  MoviesVideosRepository(super.db);



  Future<void> insertMovieVideoWithResults(MovieVideosModel movieVideo) async {
    await transaction(() async {
      // Insert MovieVideo
      final movieVideoId = await into(movieVideos).insert(
        MovieVideosCompanion(
          id: Value(movieVideo.id),
        ),
        mode: InsertMode.insertOrIgnore, // Ensure unique insertion
      );

      // Insert associated VideoResults
      if (movieVideo.results != null) {
        for (final result in movieVideo.results!) {
          await into(db.videoResult).insert(
            VideoResultCompanion(
              name: Value(result.name),
              key: Value(result.key),
              movieVideosId: Value(movieVideoId),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
      }
    });
  }

  Future<List<MovieVideoWithResults>> fetchMovieVideosById(int id) async {
    final query = select(movieVideos).join([
      leftOuterJoin(
        db.videoResult,
        db.videoResult.movieVideosId.equalsExp(movieVideos.id),
      ),
    ])
      ..where(movieVideos.id.equals(id));

    final rows = await query.get();

    return rows.map((row) {
      final movieVideo = row.readTable(movieVideos);
      final videoResults = row.readTable(db.videoResult);
      return MovieVideoWithResults(
        movieVideo: movieVideo,
        videoResults: [videoResults],
      );
    }).toList();
  }
}

// Helper class to structure results with their associated video results
class MovieVideoWithResults {
  final MovieVideo movieVideo;
  final List<VideoResultData> videoResults;

  MovieVideoWithResults({
    required this.movieVideo,
    required this.videoResults,
  });
}

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:tentwenty_test/app/database/tables/movie_details/movie_details.dart';
import 'package:tentwenty_test/app/database/tables/movie_videos/movie_videos.dart';
import 'package:tentwenty_test/app/database/tables/movie_videos/video_result.dart';
import 'package:tentwenty_test/app/database/tables/upcoming_movies/movies.dart';
import 'package:tentwenty_test/app/models/movies_details.dart';

import 'repositories/movie_videos_repository.dart';
import 'repositories/movies_detail_repository.dart';
import 'repositories/movies_repository.dart';

part 'tentwenty_database.g.dart';

@DriftDatabase(
    tables: [MovieDetails, VideoResult, Movies, MovieVideos],
    daos: [MoviesVideosRepository, MoviesDetailRepository, MoviesRepository])
class TestDatabase extends _$TestDatabase {
  TestDatabase({QueryExecutor? executor, String? dbFileFullPath})
      : super(executor ?? _openConnection(dbFileFullPath!));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) {
          return m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection(String dbFileFullPath) {
  return LazyDatabase(() async {
    final file = File(dbFileFullPath);
    return NativeDatabase.createInBackground(file);
  });
}

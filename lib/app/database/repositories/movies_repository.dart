import 'package:drift/drift.dart';
import 'package:tentwenty_test/app/database/tables/upcoming_movies/movies.dart';
import 'package:tentwenty_test/app/database/tentwenty_database.dart';
import 'package:tentwenty_test/app/models/upcoming_model.dart';

part 'movies_repository.g.dart';

@DriftAccessor(tables: [Movies])
class MoviesRepository extends DatabaseAccessor<TestDatabase>
    with _$MoviesRepositoryMixin {
  MoviesRepository(super.db);
  Future<void> insertMovie(MovieModel movie) async {
    await into(movies).insert(
      MoviesCompanion(
        adult: Value(movie.adult),
        backdropPath: Value(movie.backdropPath),
        id: Value(movie.id),
        originalTitle: Value(movie.originalTitle),
        overview: Value(movie.overview),
        posterPath: Value(movie.posterPath),
        title: Value(movie.title),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> insertMovies(List<MovieModel> movies) async {
    await batch((batch) {
      for (final movie in movies) {
        batch.insert(
          db.movies,
          MoviesCompanion(
            adult: Value(movie.adult),
            backdropPath: Value(movie.backdropPath),
            id: Value(movie.id),
            originalTitle: Value(movie.originalTitle),
            overview: Value(movie.overview),
            posterPath: Value(movie.posterPath),
            title: Value(movie.title),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Future<List<MovieModel>> fetchMovies() async {
    final query = select(movies);
    final rows = await query.get();

    return rows.map((row) {
      return MovieModel(
        adult: row.adult,
        backdropPath: row.backdropPath,
        id: row.id,
        originalTitle: row.originalTitle,
        overview: row.overview,
        posterPath: row.posterPath,
        title: row.title,
      );
    }).toList();
  }
}

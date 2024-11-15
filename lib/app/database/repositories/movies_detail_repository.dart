import 'package:drift/drift.dart';
import 'package:tentwenty_test/app/database/tables/movie_details/movie_details.dart';
import 'package:tentwenty_test/app/database/tentwenty_database.dart';

part 'movies_detail_repository.g.dart';

@DriftAccessor(tables: [MovieDetails])
class MoviesDetailRepository extends DatabaseAccessor<TestDatabase>
    with _$MoviesDetailRepositoryMixin {
  MoviesDetailRepository(super.db);

  Future<void> insertMovieDetails(MovieDetail movieDetails) async {
    await into(db.movieDetails).insert(movieDetails);
  }

  Future<List<MovieDetail>> getMovieDetails(int id) async {
    return (select(db.movieDetails)..where((t) => t.id.equals(id))).get();
  }
}

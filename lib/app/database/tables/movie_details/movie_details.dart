import 'package:drift/drift.dart';
import 'package:tentwenty_test/app/database/tables/common_table.dart';
import 'package:tentwenty_test/app/models/movies_details.dart';

class MovieDetails extends CommonTable {
  @JsonKey('backdropPath')
  TextColumn get backdropPath => text().nullable()();

  @JsonKey('originalTitle')
  TextColumn get originalTitle => text().nullable()();

  @JsonKey('overview')
  TextColumn get overview => text().nullable()();

  @JsonKey('popularity')
  RealColumn get popularity => real().nullable()();

  @JsonKey('posterPath')
  TextColumn get posterPath => text().nullable()();

  @JsonKey('title')
  TextColumn get title => text().nullable()();

  @JsonKey("genre")
  TextColumn get genre => text().map(const GenreModelConverter()).nullable()();
}

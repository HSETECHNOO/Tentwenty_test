import 'package:drift/drift.dart';
import 'package:tentwenty_test/app/database/tables/common_table.dart';

class Movies extends CommonTable {
  @JsonKey('adult')
  BoolColumn get adult => boolean().nullable()();

  @JsonKey('backdrop_path')
  TextColumn get backdropPath => text().nullable()();

  @JsonKey('original_title')
  TextColumn get originalTitle => text().nullable()();

  @JsonKey('overview')
  TextColumn get overview => text().nullable()();

  @JsonKey('poster_path')
  TextColumn get posterPath => text().nullable()();

  @JsonKey('title')
  TextColumn get title => text().nullable()();
}

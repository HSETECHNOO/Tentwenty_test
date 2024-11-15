import 'package:drift/drift.dart';
import 'package:tentwenty_test/app/database/tables/common_table.dart';

class VideoResult extends CommonTable {
  @JsonKey('name')
  TextColumn get name => text().withLength(max: 255).nullable()();

  @JsonKey('key')
  TextColumn get key => text().withLength(max: 255).nullable()();

  @JsonKey('movieVideosId')
  IntColumn get movieVideosId => integer().nullable()();
}

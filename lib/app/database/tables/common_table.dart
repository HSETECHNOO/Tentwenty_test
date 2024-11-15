import 'package:drift/drift.dart';

// @formatter:off
abstract class CommonTable extends Table {
  @JsonKey('local_id')
  IntColumn get localId => integer().autoIncrement().nullable()();
  @JsonKey('id')
  IntColumn get id => integer().unique().nullable()();

  @JsonKey('created_at')
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now()).nullable()();

  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @JsonKey('version')
  IntColumn get version => integer().clientDefault(() => 0).nullable()();

  @JsonKey('synced_at')
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

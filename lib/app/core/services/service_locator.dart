import 'dart:io';
import 'package:path/path.dart' as p;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:tentwenty_test/app/core/configs/app_default_serializer.dart';
import 'package:tentwenty_test/app/database/tentwenty_database.dart';
import 'package:tentwenty_test/app/services/movie_videos_service.dart';
import 'package:tentwenty_test/app/services/movies_details_service.dart';
import 'package:tentwenty_test/app/services/upcoming_movies_service.dart';

final GetIt locator = GetIt.instance;
late final TestDatabase database;
late final Directory supportDirectory;
late final Directory dbDirectory;
const String appSlug = 'tentwenty';
const String appVersion = '1.0.0';

void setupServiceLocator() async {
  driftRuntimeOptions.defaultSerializer = const AppDefaultSerializer();
  supportDirectory = await getApplicationSupportDirectory();
  dbDirectory = Directory(p.join(supportDirectory.path, 'database'));
  await dbDirectory.create(recursive: true);
  final String dbFileFullPath =
      p.join(dbDirectory.path, '${appSlug}_$appVersion.sqlite');
  database = TestDatabase(dbFileFullPath: dbFileFullPath);
  await database.customSelect('SELECT 1').get();
  locator.registerLazySingleton(() => UpcomingMoviesApiService());
  locator.registerLazySingleton(() => MoviesDetailsApiService());
  locator.registerLazySingleton(() => MoviesVideosApiService());
}

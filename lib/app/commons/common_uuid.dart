import 'package:uuid/uuid.dart';

class CommonUuidHelper {
  static String getUuid() {
    return const Uuid().v4();
  }
}

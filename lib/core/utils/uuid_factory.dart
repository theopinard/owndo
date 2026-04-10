import 'package:uuid/uuid.dart';

abstract final class UuidFactory {
  static const _uuid = Uuid();

  static String generate() => _uuid.v4();
}

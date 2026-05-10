import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DROPBOX_APP_KEY', obfuscate: true)
  static String dropboxAppKey = _Env.dropboxAppKey;

  @EnviedField(varName: 'DROPBOX_APP_SECRET', obfuscate: true)
  static String dropboxAppSecret = _Env.dropboxAppSecret;
}

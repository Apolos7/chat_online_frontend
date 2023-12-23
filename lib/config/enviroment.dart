import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Enviroment {
  static String get fileName =>
      const String.fromEnvironment('profile', defaultValue: 'dev') == 'prd'
          ? 'application.env.production'
          : 'application.env.development';

  static ProfileEnum get profile => ProfileEnum.values.firstWhere(
      (ProfileEnum e) => (dotenv.env['PROFILE'] ?? 'dev') == e.toString().split('.')[1],
      orElse: () => ProfileEnum.dev);

  static bool get https => bool.parse(dotenv.env['HTTPS'] ?? 'false');

  static String get apiUrl => dotenv.env['API_URL'] ?? '0.0.0.0';

  static String get webSocketAPIUrl => dotenv.env['API_BACKEND_WEBSOCKET'] ?? '0.0.0.0';
}

enum ProfileEnum { dev, prd }
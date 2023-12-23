import 'package:chat_online_frontend/config/Enviroment.dart';

abstract class BaseService {

  Uri getCompleteUrl(String path, {Map<String, dynamic>? queryParameters}) {
    if (Enviroment.https) {
      return Uri.https(Enviroment.apiUrl, path, queryParameters);
    }
    return Uri.http(Enviroment.apiUrl, path, queryParameters);
  }

}
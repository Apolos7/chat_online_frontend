import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_online_frontend/model/dto/sign_in_dto.dart';
import 'package:chat_online_frontend/service/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UserService extends BaseService {
  static final UserService _singleton = UserService._internal();
  factory UserService() {
    return _singleton;
  }
  UserService._internal();

  Future<String> authenticateUser(
      {required String username, required String password}) async {

    Uri url = getCompleteUrl('/authenticate');
    try {
      Response response = await http.post(url,
          body: jsonEncode(<String, String>{'username': username, 'password': password}),
          headers: <String, String>{
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        return "Bearer ${response.headers['authorization']}";
      }
      return Future<String>.error('wrong username or password');
    } on ClientException catch (e) {
      log(e.message, time: DateTime.now());
      return Future<String>.error(e.message);
    } on SocketException catch (e) {
      log(e.message, time: DateTime.now());
      return Future<String>.error('Unable to connect to the server');
    } on FormatException catch (e) {
      log(e.message, time: DateTime.now());
      return Future<String>.error(
          'Error while reading the data brought from the server');
    }
  }

  Future<Object> registerUser(
      {required String username, required String password}) async {
    final Uri url = getCompleteUrl('/user');
    try {
      Response response = await http.post(url,
          body: jsonEncode(<String, String>{'username': username, 'password': password}),
          headers: <String, String>{
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        return SignInDTO.fromJson(jsonDecode(response.body));
      }
      return Future<String>.error('something went wrong, try again later');
    } on ClientException catch (e) {
      log(e.message, time: DateTime.now());
      return Future<String>.error(e.message);
    } on SocketException catch (e) {
      log(e.message, time: DateTime.now());
      return Future<String>.error('Unable to connect to the server');
    } on FormatException catch (e) {
      log(e.message, time: DateTime.now());
      return Future<String>.error(
          'Error while reading the data brought from the server');
    }
  }
}

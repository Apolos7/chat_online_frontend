import 'dart:developer';
import 'dart:io';
import 'package:chat_online_frontend/config/api_constants.dart';
import 'package:chat_online_frontend/model/dto/sign_in_dto.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static final UserService _singleton = UserService._internal();
  factory UserService() {
    return _singleton;
  }
  UserService._internal();

  Future<String> authenticateUser(
      {required String username, required String password}) async {
    var url = Uri.parse("${APIConstants.API_BACKEND}/authenticate");
    try {
      var response = await http.post(url,
          body: jsonEncode({'username': username, 'password': password}),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        return "Bearer ${response.headers['authorization']}";
      }
      return Future.error("wrong username or password");
    } on ClientException catch (e) {
      log(e.message, time: DateTime.now());
      return Future.error(e.message);
    } on SocketException catch (e) {
      log(e.message, time: DateTime.now());
      return Future.error('Unable to connect to the server');
    } on FormatException catch (e) {
      log(e.message, time: DateTime.now());
      return Future.error(
          'Error while reading the data brought from the server');
    }
  }

  Future registerUser(
      {required String username, required String password}) async {
    var url = Uri.parse("${APIConstants.API_BACKEND}/user");
    try {
      var response = await http.post(url,
          body: jsonEncode({'username': username, 'password': password}),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        return SignInDTO.fromJson(jsonDecode(response.body));
      }
      return Future.error("something went wrong, try again later");
    } on ClientException catch (e) {
      log(e.message, time: DateTime.now());
      return Future.error(e.message);
    } on SocketException catch (e) {
      log(e.message, time: DateTime.now());
      return Future.error('Unable to connect to the server');
    } on FormatException catch (e) {
      log(e.message, time: DateTime.now());
      return Future.error(
          'Error while reading the data brought from the server');
    }
  }
}

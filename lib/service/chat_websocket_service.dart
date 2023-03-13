import 'dart:developer';

import 'package:chat_online_frontend/config/api_constants.dart';
import 'package:web_socket_channel/io.dart';

class ChatWebSocketService {

  late IOWebSocketChannel channel;

  Future _initConnection() async {
    log('Initiating connection.');
    channel = IOWebSocketChannel.connect(
      "${APIConstants.API_BACKEND_WEBSOCKET}/chat",
      headers: {"Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBcG9sb3M3IiwiZXhwIjoxNjgxODk2NDk0LCJpYXQiOjE2Nzg2NTY0OTR9.GK7MJXRhmGn1pXb4W5P7TqbJxoLqs1CY1Erg_tG1Gg--loK8o81yn5jog1SJxEGXzl0bYoJr3JmnnqRB6XXtmQ"},
      pingInterval: const Duration(seconds: 2),
    );
    log('Connection initiated successfully.');
  }

  Future broadcastData({required Function(String) onRecive }) async {
    _initConnection();
    channel.stream.listen((message) {
      onRecive(message);
    }, onError: (error) {

    }, onDone: () {

    }, cancelOnError: true);
  }

  Future sendMessage({required String message}) async {
    channel.sink.add(message);
  }

}
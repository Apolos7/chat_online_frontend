import 'dart:developer';
import 'package:chat_online_frontend/config/Enviroment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class ChatWebSocketService {

  late IOWebSocketChannel _channel;

  Future _initConnection() async {
    log('Initiating connection.');
    final SharedPreferences shared = await SharedPreferences.getInstance();
    final String? token = shared.getString('token');
    _channel = IOWebSocketChannel.connect(
      '${Enviroment.apiUrl}/chat',
      headers: <String, String?>{'Authorization': token},
      pingInterval: const Duration(seconds: 2),
    );
    log('Connection initiated successfully.');
  }

  Future broadcastData({required Function(String) onRecive}) async {
    await _initConnection();
    _channel.stream.listen((message) {
      onRecive(message);
    }, onError: (error) {
      // TODO: Retry connection
    }, cancelOnError: true);
  }

  Future sendMessage({required String message}) async {
    _channel.sink.add(message);
  }

  Future closeConnection() async {
    _channel.sink.close();
  }
}
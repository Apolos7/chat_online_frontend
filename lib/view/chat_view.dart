import 'dart:convert';
import 'dart:developer';

import 'package:chat_online_frontend/componenets/connection_bubble_widget.dart';
import 'package:chat_online_frontend/componenets/input_message_widget.dart';
import 'package:chat_online_frontend/componenets/message_bubble_widget.dart';
import 'package:chat_online_frontend/model/message.dart';
import 'package:chat_online_frontend/service/chat_websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.username, required this.token})
      : super(key: key);

  final String username;
  final String token;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageEditingController =
      TextEditingController();
  final List<Message> messageList = [];
  final ScrollController scrollController = ScrollController();
  final ChatWebSocketService chatWEbSocket = ChatWebSocketService();

  @override
  void initState() {
    super.initState();
    chatWEbSocket.broadcastData(onRecive: (message) {
      log(message);
      setState(() {
        messageList.insert(0, Message.fromJson(jsonDecode(message)));
      });
    });
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      messageEditingController.clear();
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      chatWEbSocket.sendMessage(message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF36393f),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0XFF23272a),
        elevation: 1,
        title: const Text('WebSocket Chat', style: TextStyle(fontSize: 16)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messageList.length,
                  reverse: true,
                  controller: scrollController,
                  itemBuilder: (context, index) =>
                      _buildItem(index, messageList[index]),
                ),
              ),
              InputMessageWidget(
                messageEditingController: messageEditingController,
                handleSubmit: sendMessage,
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildItem(int index, Message message) {
    final isMe = message.from == widget.username;
    return message.type == "CHAT"
        ? MessageBubbleWidget(chatMessage: message, isMe: isMe)
        : ConnectionBubbleWidget(chatMessage: message);
  }
}

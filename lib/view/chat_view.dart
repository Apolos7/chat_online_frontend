import 'dart:convert';
import 'dart:developer';

import 'package:chat_online_frontend/components/connection_bubble_widget.dart';
import 'package:chat_online_frontend/components/input_message_widget.dart';
import 'package:chat_online_frontend/components/message_bubble_widget.dart';
import 'package:chat_online_frontend/model/message.dart';
import 'package:chat_online_frontend/service/chat_websocket_service.dart';
import 'package:chat_online_frontend/view/sign_in_view.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.username, super.key});

  final String username;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController messageEditingController =
      TextEditingController();
  final List<Message> messageList = <Message>[];
  final ScrollController scrollController = ScrollController();
  final ChatWebSocketService chatService = ChatWebSocketService();

  @override
  void initState() {
    super.initState();
    chatService.broadcastData(onRecive: (String message) {
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
      chatService.sendMessage(message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                chatService.closeConnection();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const SignInView(),
                ));
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
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
                  itemBuilder: (BuildContext context, int index) =>
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

  StatelessWidget _buildItem(int index, Message message) {
    final bool isMe = message.from == widget.username;
    return message.type == 'CHAT'
        ? MessageBubbleWidget(chatMessage: message, isMe: isMe)
        : ConnectionBubbleWidget(chatMessage: message);
  }
}

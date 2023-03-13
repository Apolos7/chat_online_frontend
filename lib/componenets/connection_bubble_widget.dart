

import 'package:chat_online_frontend/model/message.dart';
import 'package:flutter/material.dart';

class ConnectionBubbleWidget extends StatelessWidget {
  const ConnectionBubbleWidget({
    Key? key,
    required this.chatMessage
  }) : super(key: key);

  final Message chatMessage;

  @override
  Widget build(BuildContext context) {
    bool isConnect = chatMessage.type == "CONNECT";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(
                minHeight: 50,
                minWidth: 160,
              ),
              decoration: BoxDecoration(
                color: isConnect ? Colors.blueAccent.shade700 : Colors.redAccent.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${chatMessage.from} logged in',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
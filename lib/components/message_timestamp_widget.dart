import 'package:chat_online_frontend/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

class MessageTimestampWidget extends StatelessWidget {
  const MessageTimestampWidget({
    required this.date, super.key,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    const String datePattern = 'dd MMM yyyy, HH:mm';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        date.format(datePattern),
        style: const TextStyle(
            color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}
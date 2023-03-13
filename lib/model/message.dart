import 'package:chat_online_frontend/extensions/date_time_extension.dart';

class Message {
  String? from;
  String? type;
  String? content;
  DateTime? date;

  Message({this.from, this.type, this.content, this.date});

  Message.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    type = json['type'];
    content = json['content'];
    date = DateTimeExtension.parseFromService(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['type'] = type;
    data['date'] = date!.format(DateTimeExtension.datePattern);
    data['content'] = content;
    return data;
  }
}

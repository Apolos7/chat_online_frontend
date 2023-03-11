class Menssage {
  String? from;
  String? content;

  Menssage({this.from, this.content});

  Menssage.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['content'] = this.content;
    return data;
  }
}
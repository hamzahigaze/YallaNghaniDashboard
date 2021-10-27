import 'dart:convert';

class Message {
  String title;

  String content;

  String senderName;

  String date;

  String id;

  Message({
    this.title,
    this.content,
    this.senderName,
    this.date,
    this.id,
  });

  Message copyWith({
    String title,
    String content,
    String senderName,
    String date,
    String id,
  }) {
    return Message(
      title: title ?? this.title,
      content: content ?? this.content,
      senderName: senderName ?? this.senderName,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'senderName': senderName,
      'date': date,
      'id': id,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      title: map['title'],
      content: map['content'],
      senderName: map['senderName'],
      date: (map['date'] as String).substring(0, 16).replaceAll('T', ' '),
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(title: $title, content: $content, senderName: $senderName, date: $date, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.title == title &&
        other.content == content &&
        other.senderName == senderName &&
        other.date == date &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        senderName.hashCode ^
        date.hashCode ^
        id.hashCode;
  }
}

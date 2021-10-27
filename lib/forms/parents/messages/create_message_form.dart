class CreateMessageFrom {
  String title = "";
  String content = "";
  DateTime date;
  String senderName;

  Map<String, String> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date.toUtc().toString().replaceAll(' ', 'T'),
      'senderName': senderName,
    };
  }

  bool hasEmptyFields() {
    return title.isEmpty || content.isEmpty || senderName.isEmpty;
  }
}

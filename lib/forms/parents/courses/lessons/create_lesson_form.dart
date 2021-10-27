class CreateLessonForm {
  DateTime date = DateTime.now().toUtc();

  String paymentNote = "";

  String summary = "";

  String get dateAsString {
    var dateAsString = date.toString();
    return dateAsString.replaceFirst(' ', 'T');
  }

  Map<String, dynamic> toMap() {
    return {
      'date': dateAsString,
      'paymentNote': paymentNote,
      'summary': summary
    };
  }
}

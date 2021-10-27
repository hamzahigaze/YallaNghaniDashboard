class EditLessonForm {
  String paymentNote;

  DateTime date;

  String summary;

  String get dateAsString {
    if (date == null) return null;

    var dateAsString = date.toString();
    return dateAsString.replaceFirst(' ', 'T');
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (date != null) map['date'] = dateAsString;

    if (paymentNote != null) map['paymentNote'] = paymentNote;

    if (summary != null) map['summary'] = summary;

    return map;
  }
}

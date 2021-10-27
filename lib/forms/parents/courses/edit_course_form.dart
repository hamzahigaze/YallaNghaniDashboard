class EditCourseForm {
  String title;

  String studentName;

  String lessonFee;

  bool hasEmptyFields() {
    return (title != null && title.isEmpty) ||
        lessonFee != null && lessonFee.isEmpty ||
        studentName != null && studentName.isEmpty;
  }

  bool isDoubleLessonFee() {
    return lessonFeeNumericValue != null;
  }

  double get lessonFeeNumericValue {
    return double.tryParse(lessonFee);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    if (title != null) map['title'] = title;
    if (studentName != null) map['studentName'] = studentName;
    if (lessonFee != null) map['lessonFee'] = lessonFeeNumericValue;
    return map;
  }

  @override
  String toString() =>
      'UpdateCourseForm(title: $title, studentName: $studentName, lessonFee: $lessonFee)';
}

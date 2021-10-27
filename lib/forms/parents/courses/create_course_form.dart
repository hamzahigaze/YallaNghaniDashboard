class CreateCourseForm {
  String teacherId = "";

  String title = "";

  String studentName = "";

  String lessonFee = "";

  bool hasEmptyFields() {
    return teacherId.isEmpty ||
        title.isEmpty ||
        studentName.isEmpty ||
        lessonFee.isEmpty;
  }

  bool isDoubleLessonFee() {
    return lessonFeeNumericValue != null;
  }

  double get lessonFeeNumericValue {
    return double.tryParse(lessonFee);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'studentName': studentName,
      'lessonFee': lessonFeeNumericValue,
      'teacherId': teacherId
    };
  }
}

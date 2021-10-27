class EditOfferedCourseForm {
  String title;

  String description;

  String teacherName;

  String teacherDescription;

  bool isEducational;

  String imageUrl;

  bool hasEmptyFields() {
    return (title != null && title.isEmpty) ||
        (description != null && description.isEmpty) ||
        (teacherName != null && teacherName.isEmpty) ||
        (teacherDescription != null && teacherDescription.isEmpty) ||
        (imageUrl != null && imageUrl.isEmpty);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (title != null) map['title'] = title;

    if (description != null) map['description'] = description;

    if (teacherName != null) map['teacherName'] = teacherName;

    if (teacherDescription != null)
      map['teacherDescription'] = teacherDescription;

    if (imageUrl != null) map['imageUrl'] = imageUrl;

    if (isEducational != null) map['isEducational'] = isEducational;

    return map;
  }
}

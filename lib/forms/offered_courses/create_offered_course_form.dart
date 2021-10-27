class CreateOfferedCourseForm {
  String title;

  String imageUrl;

  String description;

  String teacherName;

  String teacherDescription;

  bool isEducational;

  CreateOfferedCourseForm({
    this.title = '',
    this.imageUrl = '',
    this.description = '',
    this.teacherName = '',
    this.teacherDescription = '',
    this.isEducational = true,
  });

  bool hasEmptyFields() {
    return title.isEmpty ||
        imageUrl.isEmpty ||
        description.isEmpty ||
        teacherName.isEmpty ||
        teacherDescription.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'teacherName': teacherName,
      'teacherDescription': teacherDescription,
      'isEducational': isEducational,
    };
  }
}

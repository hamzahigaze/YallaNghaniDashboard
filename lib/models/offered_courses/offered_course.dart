import 'dart:convert';

class OfferedCourse {
  String id;

  String title;

  String description;

  String teacherName;

  String teacherDescription;

  bool isEducational;

  String imageUrl;
  OfferedCourse({
    this.id,
    this.title,
    this.description,
    this.teacherName,
    this.teacherDescription,
    this.isEducational,
    this.imageUrl,
  });

  OfferedCourse copyWith({
    String id,
    String title,
    String description,
    String teacherName,
    String teacherDescription,
    bool isEducational,
    String imageUrl,
  }) {
    return OfferedCourse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherName: teacherName ?? this.teacherName,
      teacherDescription: teacherDescription ?? this.teacherDescription,
      isEducational: isEducational ?? this.isEducational,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacherName': teacherName,
      'teacherDescription': teacherDescription,
      'isEducational': isEducational,
      'imageUrl': imageUrl,
    };
  }

  factory OfferedCourse.fromMap(Map<String, dynamic> map) {
    return OfferedCourse(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      teacherName: map['teacherName'],
      teacherDescription: map['teacherDescription'],
      isEducational: map['isEducational'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferedCourse.fromJson(String source) =>
      OfferedCourse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OfferedCourse(id: $id, title: $title, description: $description, teacherName: $teacherName, teacherDescription: $teacherDescription, isEducational: $isEducational, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfferedCourse &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.teacherName == teacherName &&
        other.teacherDescription == teacherDescription &&
        other.isEducational == isEducational &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        teacherName.hashCode ^
        teacherDescription.hashCode ^
        isEducational.hashCode ^
        imageUrl.hashCode;
  }
}

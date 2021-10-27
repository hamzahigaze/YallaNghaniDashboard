import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:yalla_dashboard/models/lessons_dates/lesson_date.dart';

class Course {
  String id;

  String title;

  String parentId;

  String studentName;

  List<LessonDate> lessonsDates;
  Course({
    this.id,
    this.title,
    this.parentId,
    this.studentName,
    this.lessonsDates,
  });

  Course copyWith({
    String id,
    String title,
    String parentId,
    String studentName,
    List<LessonDate> lessonsDates,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      parentId: parentId ?? this.parentId,
      studentName: studentName ?? this.studentName,
      lessonsDates: lessonsDates ?? this.lessonsDates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'parentId': parentId,
      'studentName': studentName,
      'lessonsDates': lessonsDates?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      title: map['title'],
      parentId: map['parentId'],
      studentName: map['studentName'],
      lessonsDates: List<LessonDate>.from(
          map['lessonsDates']?.map((x) => LessonDate.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Course(id: $id, title: $title, parentId: $parentId, studentName: $studentName, lessonsDates: $lessonsDates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.title == title &&
        other.parentId == parentId &&
        other.studentName == studentName &&
        listEquals(other.lessonsDates, lessonsDates);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        parentId.hashCode ^
        studentName.hashCode ^
        lessonsDates.hashCode;
  }
}

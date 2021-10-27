import 'dart:convert';

import 'package:flutter/foundation.dart';

import './lesson.dart';
import '../lessons_dates/lesson_date.dart';
import './payment.dart';

class Course {
  String id;

  String title;

  String teacherId;

  String studentName;

  String teacherName;

  double lessonFee;

  double parentBalance;

  List<Payment> payments;

  List<Lesson> lessons;

  List<LessonDate> lessonsDates;
  Course({
    this.id,
    this.title,
    this.teacherId,
    this.studentName,
    this.teacherName,
    this.lessonFee,
    this.parentBalance,
    this.payments,
    this.lessons,
    this.lessonsDates,
  });

  Course copyWith({
    String id,
    String title,
    String teacherId,
    String studentName,
    String teacherName,
    double lessonFee,
    double parentBalance,
    List<Payment> payments,
    List<Lesson> lessons,
    List<LessonDate> lessonsDates,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      teacherId: teacherId ?? this.teacherId,
      studentName: studentName ?? this.studentName,
      teacherName: teacherName ?? this.teacherName,
      lessonFee: lessonFee ?? this.lessonFee,
      parentBalance: parentBalance ?? this.parentBalance,
      payments: payments ?? this.payments,
      lessons: lessons ?? this.lessons,
      lessonsDates: lessonsDates ?? this.lessonsDates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'teacherId': teacherId,
      'studentName': studentName,
      'teacherName': teacherName,
      'lessonFee': lessonFee,
      'parentBalance': parentBalance,
      'payments': payments?.map((x) => x.toMap())?.toList(),
      'lessons': lessons?.map((x) => x.toMap())?.toList(),
      'lessonsDates': lessonsDates?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      title: map['title'],
      teacherId: map['teacherId'],
      studentName: map['studentName'],
      teacherName: map['teacherName'],
      lessonFee: map['lessonFee'],
      parentBalance: map['parentBalance'],
      payments:
          List<Payment>.from(map['payments']?.map((x) => Payment.fromMap(x))),
      lessons: List<Lesson>.from(map['lessons']?.map((x) => Lesson.fromMap(x))),
      lessonsDates: List<LessonDate>.from(
          map['lessonsDates']?.map((x) => LessonDate.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Course(id: $id, title: $title, teacherId: $teacherId, studentName: $studentName, teacherName: $teacherName, lessonFee: $lessonFee, parentBalance: $parentBalance, payments: $payments, lessons: $lessons, lessonsDates: $lessonsDates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.title == title &&
        other.teacherId == teacherId &&
        other.studentName == studentName &&
        other.teacherName == teacherName &&
        other.lessonFee == lessonFee &&
        other.parentBalance == parentBalance &&
        listEquals(other.payments, payments) &&
        listEquals(other.lessons, lessons) &&
        listEquals(other.lessonsDates, lessonsDates);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        teacherId.hashCode ^
        studentName.hashCode ^
        teacherName.hashCode ^
        lessonFee.hashCode ^
        parentBalance.hashCode ^
        payments.hashCode ^
        lessons.hashCode ^
        lessonsDates.hashCode;
  }
}

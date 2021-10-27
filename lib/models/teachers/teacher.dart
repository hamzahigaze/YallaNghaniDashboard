import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:yalla_dashboard/models/teachers/course.dart';

class Teacher {
  String id;

  String firstName;

  String lastName;

  List<Course> courses;

  String phoneNumber;
  Teacher({
    this.id,
    this.firstName,
    this.lastName,
    this.courses,
    this.phoneNumber,
  });

  Teacher copyWith({
    String id,
    String firstName,
    String lastName,
    List<Course> courses,
    String phoneNumber,
  }) {
    return Teacher(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      courses: courses ?? this.courses,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'courses': courses?.map((x) => x.toMap())?.toList(),
      'phoneNumber': phoneNumber,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      courses: List<Course>.from(map['courses']?.map((x) => Course.fromMap(x))),
      phoneNumber: map['phoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Teacher(id: $id, firstName: $firstName, lastName: $lastName, courses: $courses, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Teacher &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        listEquals(other.courses, courses) &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        courses.hashCode ^
        phoneNumber.hashCode;
  }
}

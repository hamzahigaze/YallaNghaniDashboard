import 'dart:convert';

import 'package:flutter/foundation.dart';

import './course.dart';
import './message.dart';

class Parent {
  String firstName;

  String lastName;

  String id;

  String userName;

  String image;

  String phoneNumber;

  List<Course> courses;

  List<Message> messages;

  int newMessagesCount;

  Parent(
      {this.firstName,
      this.lastName,
      this.id,
      this.userName,
      this.image,
      this.phoneNumber,
      this.courses,
      this.messages,
      this.newMessagesCount});

  Parent copyWith({
    String firstName,
    String lastName,
    String id,
    String userName,
    String image,
    String phoneNumber,
    List<Course> courses,
    List<Message> messages,
    int newMessagesCount,
  }) {
    return Parent(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      id: id ?? this.id,
      userName: userName ?? this.userName,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      courses: courses ?? this.courses,
      messages: messages ?? this.messages,
      newMessagesCount: newMessagesCount ?? this.newMessagesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'id': id,
      'userName': userName,
      'image': image,
      'phoneNumber': phoneNumber,
      'courses': courses?.map((x) => x.toMap())?.toList(),
      'messages': messages?.map((x) => x.toMap())?.toList(),
      'newMessagesCount': newMessagesCount,
    };
  }

  factory Parent.fromMap(Map<String, dynamic> map) {
    return Parent(
      firstName: map['firstName'],
      lastName: map['lastName'],
      id: map['id'],
      userName: map['userName'],
      image: map['image'],
      phoneNumber: map['phoneNumber'],
      courses: List<Course>.from(map['courses']?.map((x) => Course.fromMap(x))),
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      newMessagesCount: map['newMessagesCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Parent.fromJson(String source) => Parent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Parent(firstName: $firstName, lastName: $lastName, id: $id, userName: $userName, image: $image, phoneNumber: $phoneNumber, courses: $courses, messages: $messages, newMessagesCount: $newMessagesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Parent &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.id == id &&
        other.userName == userName &&
        other.image == image &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.courses, courses) &&
        listEquals(other.messages, messages) &&
        other.newMessagesCount == newMessagesCount;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        id.hashCode ^
        userName.hashCode ^
        image.hashCode ^
        phoneNumber.hashCode ^
        courses.hashCode ^
        messages.hashCode ^
        newMessagesCount.hashCode;
  }
}

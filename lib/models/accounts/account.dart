import 'dart:convert';

import 'package:flutter/foundation.dart';

class Account {
  String firstName;
  String lastName;
  String phoneNumber;
  String userName;
  String id;
  String role;
  Account({
    @required this.firstName,
    @required this.lastName,
    @required this.phoneNumber,
    @required this.userName,
    @required this.id,
    @required this.role,
  });

  Account copyWith({
    String firstName,
    String lastName,
    String phoneNumber,
    String userName,
    String id,
    String role,
  }) {
    return Account(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
      id: id ?? this.id,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'id': id,
      'role': role,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      userName: map['userName'],
      id: map['id'],
      role: map['role'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Account(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, userName: $userName, id: $id, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.userName == userName &&
        other.id == id &&
        other.role == role;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        phoneNumber.hashCode ^
        userName.hashCode ^
        id.hashCode ^
        role.hashCode;
  }
}

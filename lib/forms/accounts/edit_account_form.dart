class EditAccountForm {
  String firstName;
  String lastName;
  String phoneNumber;

  EditAccountForm();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (firstName != null) map['firstName'] = firstName;
    if (lastName != null) map['lastName'] = lastName;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;

    return map;
  }

  bool hasEmptyFields() {
    return (firstName != null && firstName.isEmpty) ||
        (lastName != null && lastName.isEmpty) ||
        (phoneNumber != null && phoneNumber.isEmpty);
  }
}

class CreateAccountForm {
  String firstName = "";
  String lastName = "";
  String password = "";
  String userName = "";
  String role = "";
  String phoneNumber = "";

  bool hasEmptyFields() {
    return firstName.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty ||
        userName.isEmpty ||
        role.isEmpty ||
        phoneNumber.isEmpty;
  }

  Map<String, String> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'userName': userName,
      'role': role,
      'phoneNumber': phoneNumber,
    };
  }
}

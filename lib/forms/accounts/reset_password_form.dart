import 'dart:convert';

class ResetPasswordForm {
  String accountId;
  String password = "";

  ResetPasswordForm(this.accountId);

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'password': password,
    };
  }

  bool hasEmptyField() {
    return password.isEmpty;
  }

  String toJson() => json.encode(toMap());
}

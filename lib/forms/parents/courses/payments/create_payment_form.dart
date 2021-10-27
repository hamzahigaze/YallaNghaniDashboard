class CreatePaymentForm {
  String amount = "";

  String paymentMethod = "";

  DateTime date = DateTime.now().toUtc();

  bool hasEmptyFields() {
    return amount.isEmpty || paymentMethod.isEmpty;
  }

  bool isDoubleAmount() {
    return amounNumericalValue != null;
  }

  double get amounNumericalValue {
    return double.tryParse(amount);
  }

  String get dateAsString {
    var dateAsString = date.toString();
    return dateAsString.replaceFirst(' ', 'T');
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amounNumericalValue,
      'paymentMethod': paymentMethod,
      'date': dateAsString
    };
  }
}

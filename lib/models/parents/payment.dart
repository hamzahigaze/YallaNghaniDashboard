import 'dart:convert';

class Payment {
  double amount;

  String date;

  String paymentMethod;

  String id;

  Payment({
    this.amount,
    this.date,
    this.paymentMethod,
    this.id,
  });

  Payment copyWith({
    double amount,
    String date,
    String paymentMethod,
    String id,
  }) {
    return Payment(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'paymentMethod': paymentMethod,
      'id': id,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      amount: map['amount'],
      date: map['date'].substring(0, map['date'].indexOf('T')),
      paymentMethod: map['paymentMethod'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Payment(amount: $amount, date: $date, paymentMethod: $paymentMethod, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Payment &&
        other.amount == amount &&
        other.date == date &&
        other.paymentMethod == paymentMethod &&
        other.id == id;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        date.hashCode ^
        paymentMethod.hashCode ^
        id.hashCode;
  }
}

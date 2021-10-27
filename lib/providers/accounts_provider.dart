import 'package:flutter/cupertino.dart';
import 'package:yalla_dashboard/models/accounts/account.dart';

class AccountsProvider extends ChangeNotifier {
  List<Account> _accounts = [];

  void setAccounts(Iterable<Account> accounts) {
    _accounts.clear();

    _accounts.addAll(accounts);
    _accounts.sort((a1, a2) => a1.firstName.compareTo(a2.firstName));
    notifyListeners();
  }

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void updateAccount(Account account) {
    var index = _accounts.indexWhere((element) => element.id == account.id);

    if (index != -1) {
      _accounts[index] = account;

      notifyListeners();
    }
  }

  void removeAccount(String id) {
    _accounts.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  List<Account> get accounts {
    List<Account> accounts = [];
    accounts.addAll(_accounts);
    return accounts;
  }
}

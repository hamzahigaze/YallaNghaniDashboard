import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/models/accounts/account.dart';
import 'package:yalla_dashboard/providers/accounts_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';

part 'accounts_cubit_state.dart';

class AccountsCubit extends Cubit<AccountsCubitState> {
  AccountsCubit(this.accountsProvider) : super(AccountsCubitInitial());

  AccountsProvider accountsProvider;
  String get apiPath => '${ConstDataHelper.baseUrl}/accounts';

  Future<void> fetchAccounts() async {
    emit(AccountsCubitLoadInProgress());

    var result = await ApiCaller.request(
      url: '$apiPath/get',
      method: HttpMethod.GET,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      List<dynamic> items = jsonDecode(result.body)['outcome']['items'];

      List<Account> accounts =
          items.map<Account>((i) => Account.fromMap(i)).toList();

      accountsProvider.setAccounts(accounts);

      emit(AccountsCubitSuccess());
    } else {
      print(result);

      emit(AccountsCubitFailure());
    }
  }
}

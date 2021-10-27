import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/providers/token.dart';

part 'identity_state.dart';

class IdentityCubit extends Cubit<IdentityState> {
  IdentityCubit() : super(IdentityInitial());

  void setIdentity(String token) async {
    TokenProvider().setToken(token);
    (await SharedPreferences.getInstance())
        .setString(ConstDataHelper.tokenKey, token);
    print('token stored successfully');
    emit(IdentityExist());
  }

  void removeIdentity() async {
    TokenProvider().setToken(null);
    (await SharedPreferences.getInstance())
        .setString(ConstDataHelper.tokenKey, null);
    emit(IdentityNotExist());
  }

  void checkForIdentity() async {
    var token = (await SharedPreferences.getInstance()).getString('token');
    if (token != null)
      setIdentity(token);
    else
      removeIdentity();
  }
}

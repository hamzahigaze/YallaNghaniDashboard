import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/accounts/accounts_cubit_cubit.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/accounts/account.dart';
import 'package:yalla_dashboard/providers/accounts_provider.dart';
import 'package:yalla_dashboard/screens/accounts/create_account_dialog.dart';
import 'package:yalla_dashboard/screens/accounts/edit_account_dialog.dart';
import 'package:yalla_dashboard/screens/accounts/reset_password_dialog.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/drawers/side_menu.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key key}) : super(key: key);

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<DataRow> accountsRows;
  @override
  void initState() {
    super.initState();
    accountsRows = [];
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await BlocProvider.of<AccountsCubit>(context).fetchAccounts();
      setState(() {
        addAllAcounts();
      });
    });
  }

  void addAccountRow(Account account) {
    accountsRows.add(
      DataRow(cells: [
        DataCell(Text(account.firstName)),
        DataCell(Text(account.lastName)),
        DataCell(Text(account.userName)),
        DataCell(Text(account.phoneNumber)),
        DataCell(Text(account.role)),
        DataCell(IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => EditAccountDialog(
                account: account,
              ),
            );
          },
          color: Colors.orangeAccent,
        )),
        DataCell(IconButton(
          icon: Icon(Icons.lock),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => ResetPasswordDialog(
                accountId: account.id,
              ),
            );
          },
          color: Colors.blueAccent,
        )),
        DataCell(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteAccount(account.id),
          color: Colors.red,
        )),
      ]),
    );
  }

  void addAllAcounts() {
    accountsRows?.clear();
    Provider.of<AccountsProvider>(context, listen: false)
        .accounts
        .forEach((element) {
      addAccountRow(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الحسابات'),
        ),
        drawer: SideMenu(),
        body: BlocBuilder<AccountsCubit, AccountsCubitState>(
          builder: (context, state) {
            if (state is AccountsCubitLoadInProgress ||
                state is AccountsCubitInitial)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is AccountsCubitSuccess) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 100),
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 100,
                    width: 250,
                    child: Image(
                      image: AssetImage(
                        './assets/illustration/music/illu-3.png',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text('إنشاء حساب جديد +'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CredateAccountDialog();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  _accountsView()
                ],
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حدث خطأ أثناء جلب البيانات الخاصة بالحسابات'),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AccountsCubit>(context).fetchAccounts();
                    },
                    child: Text('إعادة المحاولة'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _accountsView() {
    return Consumer<AccountsProvider>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'عدد الحسابات الكلي : ${provider.accounts.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 25),
              Container(
                width: 250,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'بحث حسب الاسم',
                  ),
                  initialValue: '',
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        accountsRows.clear();
                        addAllAcounts();
                      } else {
                        accountsRows.clear();
                        nameSearch(value).forEach((element) {
                          addAccountRow(element);
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('الاسم الأول')),
                DataColumn(label: Text('العائلة')),
                DataColumn(label: Text('اسم المستخدم')),
                DataColumn(label: Text('رقم الهاتف')),
                DataColumn(label: Text('نوع الحساب')),
                DataColumn(label: Text('تعديل البيانات')),
                DataColumn(label: Text('تغيير كلمة المرور')),
                DataColumn(label: Text('حذف الحساب')),
              ],
              rows: accountsRows,
            ),
          )
        ],
      );
    });
  }

  void _deleteAccount(String id) async {
    //

    var isSure = await UIHelper.showDeleteConfirmationDialog(context, 'الحساب');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/accounts/$id',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Deleted account successfully');

      Provider.of<AccountsProvider>(context, listen: false).removeAccount(id);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم حذف الحساب بنجاح',
      );
    }

    ///
    else if (result is BadRequest &&
        jsonDecode(result.body)['error'] ==
            '''The teacher you are trying to delete is linked with courses for some parents. Please change any appearence of the teacher and try again.''') {
      ///
      UIHelper.showMessageDialogWithOkButton(
        context,
        'حساب المعلم الذي تحاول حذفه مربوط مع بعض الدورات للأباء. الرجاء تغيير المعلم في تلك الدورات والمحاولة من جديد',
      );
    } else if (result is BadRequest &&
        jsonDecode(result.body)['error'] ==
            "Can't delete this admin account because it's only one exist") {
      ///
      UIHelper.showMessageDialogWithOkButton(
        context,
        'لا يمكن حذف هذا الحساب لأنه حساب المدير الوحيد',
      );
    }

    ///
    else {
      print('Failed to delete account');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدثت مشكلة أثناء حذف الحساب',
      );
    }
  }

  List<Account> nameSearch(String value) {
    return Provider.of<AccountsProvider>(context, listen: false)
        .accounts
        .where(
          (element) =>
              element.firstName.contains(value) ||
              element.lastName.contains(value),
        )
        .toList();
  }
}

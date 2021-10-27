import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/accounts/create_account_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/accounts/account.dart';
import 'package:yalla_dashboard/providers/accounts_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CredateAccountDialog extends StatefulWidget {
  const CredateAccountDialog({Key key}) : super(key: key);

  @override
  _CredateAccountDialogState createState() => _CredateAccountDialogState();
}

class _CredateAccountDialogState extends State<CredateAccountDialog> {
  CreateAccountForm _form;

  @override
  void initState() {
    super.initState();
    _form = CreateAccountForm();
    _form.role = 'Parent';
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                label: 'الاسم الأول',
                onChanged: (value) => _form.firstName = value,
              ),
              Spacer(),
              DialogFormField(
                label: 'الكنية',
                onChanged: (value) => _form.lastName = value,
              )
            ],
          ),
          Row(
            children: [
              DialogFormField(
                label: 'اسم المستخدم',
                onChanged: (value) => _form.userName = value,
                textDirection: TextDirection.ltr,
              ),
              Spacer(),
              DialogFormField(
                label: 'رقم الهاتف',
                onChanged: (value) => _form.phoneNumber = value,
                textDirection: TextDirection.ltr,
              )
            ],
          ),
          Row(
            children: [
              DialogFormField(
                label: 'كلمة السر',
                onChanged: (value) => _form.password = value,
                textDirection: TextDirection.ltr,
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: _form.role,
                  items: [
                    DropdownMenuItem(
                      child: Text('Admin'),
                      value: 'Admin',
                    ),
                    DropdownMenuItem(
                      child: Text('Parent'),
                      value: 'Parent',
                    ),
                    DropdownMenuItem(
                      child: Text('Teacher'),
                      value: 'Teacher',
                    ),
                  ],
                  onChanged: (value) {
                    _form.role = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'نوع الحساب',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('إنشاء'),
                onPressed: () {
                  _submit();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (_form.hasEmptyFields()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء عدم ترك حقول فارغة',
      );
      return;
    }

    Pattern pattern = r'^(?:[+0]9)?[0-9]*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(_form.phoneNumber)) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء إخال رقم الهاتف بالصيغة الصحيحة',
      );
      return;
    }

    if (_form.password.length < 8) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'كلمة السر يجب أن تكون بطول 8 محارف',
      );

      return;
    }

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/accounts',
      method: HttpMethod.POST,
      body: jsonEncode(_form.toMap()),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Created account successfully');

      var map = jsonDecode(result.body)['outcome'];
      Account account = Account.fromMap(map);

      Provider.of<AccountsProvider>(context, listen: false).addAccount(account);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إنشاء الحساب بنجاح',
        (_) => Navigator.of(context).pop(),
      );

      return;
    }

    if (result is BadRequest) {
      if (jsonDecode(result.body)['error'] == 'User Name Already Exsist') {
        UIHelper.showMessageDialogWithOkButton(
          context,
          'اسم المستخدم موجود مسبقاً',
        );
        return;
      }
    }

    print('Failed to create account');
    print(result);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'حدث خطأ أثناء إنشاء الحساب',
    );
  }
}

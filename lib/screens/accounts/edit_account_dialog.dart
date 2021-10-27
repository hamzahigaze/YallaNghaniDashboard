import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/accounts/edit_account_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/accounts/account.dart';
import 'package:yalla_dashboard/providers/accounts_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class EditAccountDialog extends StatefulWidget {
  const EditAccountDialog({this.account, Key key}) : super(key: key);

  final Account account;
  @override
  _EditAccountDialogState createState() => _EditAccountDialogState();
}

class _EditAccountDialogState extends State<EditAccountDialog> {
  EditAccountForm _form;

  @override
  initState() {
    super.initState();
    _form = EditAccountForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                initialValue: widget.account.firstName,
                label: 'الاسم الأول',
                onChanged: (value) => _form.firstName = value,
              ),
              Spacer(),
              DialogFormField(
                initialValue: widget.account.lastName,
                label: 'الكنية',
                onChanged: (value) => _form.lastName = value,
              ),
            ],
          ),
          Row(
            children: [
              DialogFormField(
                initialValue: widget.account.phoneNumber,
                label: 'رقم الهاتف',
                onChanged: (value) => _form.phoneNumber = value,
                textDirection: TextDirection.ltr,
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                child: Text('حفظ التغييرات'),
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _saveChanges() async {
    if (!hasChanges()) {
      print('No Changes to Account were detcted');

      Navigator.of(context).pop();

      return;
    }

    if (_form.hasEmptyFields()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        ConstDataHelper.emptyFieldsError,
      );

      return;
    }

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/accounts/${widget.account.id}',
      method: HttpMethod.PUT,
      body: jsonEncode(_form.toMap()),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Succeeded editng account');

      var map = jsonDecode(result.body)['outcome'];
      Account account = Account.fromMap(map);

      Provider.of<AccountsProvider>(context, listen: false)
          .updateAccount(account);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم تعديل الحساب بنجاح',
        (_) => Navigator.of(context).pop(),
      );

      return;
    }

    print(result);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'حدث خطأ أثناء عملية تعديل الحساب',
    );
  }

  bool hasChanges() {
    return _form.firstName != null ||
        _form.lastName != null ||
        _form.phoneNumber != null;
  }
}

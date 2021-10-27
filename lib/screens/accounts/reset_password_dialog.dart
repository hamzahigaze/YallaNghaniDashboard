import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yalla_dashboard/forms/accounts/reset_password_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String accountId;

  const ResetPasswordDialog({this.accountId, Key key}) : super(key: key);

  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  ResetPasswordForm _form;

  initState() {
    super.initState();
    _form = ResetPasswordForm(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          DialogFormField(
            label: ' كلمة المرور الجديدة',
            onChanged: (value) => _form.password = value,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: _submit,
            child: Text('حفظ'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (_form.hasEmptyField()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        ConstDataHelper.emptyFieldsError,
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
        url: '${ConstDataHelper.baseUrl}/accounts/resetpassword',
        method: HttpMethod.POST,
        body: jsonEncode(_form.toMap()),
        headers: ConstDataHelper.apiCommonHeaders);

    if (result is Ok) {
      print('Rest password successfully');

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم تغيير كلمة المرور بنجاح',
        (_) => Navigator.of(context).pop(),
      );

      return;
    }

    print(result);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'حدثث مشكلة أثناء تغيير كلمة المرور',
    );
  }
}

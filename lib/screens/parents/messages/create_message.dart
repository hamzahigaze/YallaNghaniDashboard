import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/parents/messages/create_message_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/message.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CreateMessageDialog extends StatefulWidget {
  const CreateMessageDialog({Key key, this.id}) : super(key: key);

  final String id;
  @override
  _CreateMessageDialogState createState() => _CreateMessageDialogState();
}

class _CreateMessageDialogState extends State<CreateMessageDialog> {
  CreateMessageFrom _form;

  @override
  void initState() {
    super.initState();
    _form = CreateMessageFrom()..date = DateTime.now().add(Duration(hours: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DialogFormField(
                initialValue: '',
                label: 'العنوان',
                onChanged: (value) => _form.title = value,
                textDirection: TextDirection.rtl,
              ),
              Spacer(),
              DialogFormField(
                initialValue: '',
                label: 'المرسل',
                onChanged: (value) => _form.senderName = value,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
          DialogFormField(
            maxLines: 5,
            onChanged: (value) => _form.content = value,
            textDirection: TextDirection.rtl,
            initialValue: '',
            label: 'النّص',
          ),
          Center(
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text('إرسال'),
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
        ConstDataHelper.emptyFieldsError,
      );

      return;
    }

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/parents/${widget.id}/messages',
      method: HttpMethod.POST,
      body: jsonEncode(_form.toMap()),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Successful Sending');

      var id = jsonDecode(result.body)['outcome'];

      Message message = Message.fromMap({..._form.toMap(), 'id': id});

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إرسال رسالتك بنجاح',
        (_) => Navigator.of(context).pop(),
      );

      Provider.of<ParentsProvider>(context, listen: false)
          .addMessage(widget.id, message);
    } else {
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء إرسال الرسالة',
      );
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/parents/courses/payments/create_payment_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/payment.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/dialog_sumbit_button.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CreaetPaymentDialog extends StatefulWidget {
  const CreaetPaymentDialog({this.parentId, this.courseId, key})
      : super(key: key);

  final String parentId, courseId;
  @override
  _CreaetPaymentDialogState createState() => _CreaetPaymentDialogState();
}

class _CreaetPaymentDialogState extends State<CreaetPaymentDialog> {
  CreatePaymentForm _form;

  List<String> paymentMethods;

  @override
  void initState() {
    super.initState();
    paymentMethods = ['نقدي', 'شاك', 'فيزا'];
    _form = CreatePaymentForm()..paymentMethod = paymentMethods[0];
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                textDirection: TextDirection.ltr,
                onChanged: (value) => _form.amount = value,
                label: 'المبلغ',
              ),
              Spacer(),
              Container(
                width: 300,
                child: DropdownButton<String>(
                  value: _form.paymentMethod,
                  items: [
                    for (var method in paymentMethods)
                      DropdownMenuItem(
                        child: Text(method),
                        value: method,
                      )
                  ],
                  onChanged: (value) {
                    setState(() {
                      _form.paymentMethod = value;
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('التاريخ:  '),
              Text(_form.dateAsString
                  .substring(0, _form.dateAsString.indexOf('T'))),
              SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: _form.date,
                      firstDate: DateTime(2015),
                      lastDate: DateTime.now(),
                    );
                    setState(() {
                      _form.date = date;
                    });
                  },
                  child: Text('تغيير')),
              Spacer(),
            ],
          ),
          SizedBox(height: 20),
          DialogSubmitButton(
            onPressed: _submit,
            text: 'إضافة',
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

    if (!_form.isDoubleAmount()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء إدخال قيمة صحيحة في حقل المبلغ',
      );

      return;
    }

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.courseId}/payments',
      method: HttpMethod.POST,
      headers: ConstDataHelper.apiCommonHeaders,
      body: jsonEncode(_form.toMap()),
    );

    if (result is Ok) {
      var outcome = jsonDecode(result.body)['outcome'];

      Payment payment = Payment.fromMap(outcome);

      Provider.of<ParentsProvider>(context, listen: false)
          .addPayment(widget.parentId, widget.courseId, payment);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إضافة الدفعة بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to add payment');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء إضافة الدفعة',
      );
    }
  }
}

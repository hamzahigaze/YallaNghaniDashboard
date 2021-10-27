import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/parents/courses/lessons/edit_lesson_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/lesson.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/dialog_sumbit_button.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class EditLessonDialog extends StatefulWidget {
  const EditLessonDialog({this.lesson, this.parentId, this.courseId, key})
      : super(key: key);

  final String parentId, courseId;
  final Lesson lesson;
  @override
  _EditLessonDialogState createState() => _EditLessonDialogState();
}

class _EditLessonDialogState extends State<EditLessonDialog> {
  EditLessonForm _form;

  @override
  void initState() {
    super.initState();

    _form = EditLessonForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              // DialogFormField(
              //   onChanged: (value) => _form.summary = value,
              //   label: 'ملخص',
              //   initialValue: widget.lesson.summary,
              // ),
              DialogFormField(
                onChanged: (value) => _form.paymentNote = value,
                label: 'ملاحظات عن الدفع',
                initialValue: widget.lesson.paymentNote,
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('التاريخ:  '),
              Text(
                _form.dateAsString
                        ?.substring(0, _form.dateAsString.indexOf('T')) ??
                    widget.lesson.date,
              ),
              SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(widget.lesson.date),
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
            text: 'تعديل',
          )
        ],
      ),
    );
  }

  void _submit() async {
    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.courseId}/lessons/${widget.lesson.id}',
      method: HttpMethod.PUT,
      headers: ConstDataHelper.apiCommonHeaders,
      body: jsonEncode(_form.toMap()),
    );

    if (result is Ok) {
      print('Updated Lesson Successfully');

      if (_form.date != null)
        widget.lesson.date =
            _form.dateAsString.substring(0, _form.dateAsString.indexOf('T'));

      if (_form.paymentNote != null)
        widget.lesson.paymentNote = _form.paymentNote;

      // if (_form.summary != null) widget.lesson.summary = _form.summary;

      Provider.of<ParentsProvider>(context, listen: false).notifyChanges();

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم تعديل الدرس بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to update lesson');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء تعديل الدرس',
      );
    }
  }
}

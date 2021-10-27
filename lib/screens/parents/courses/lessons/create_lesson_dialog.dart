import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/parents/courses/lessons/create_lesson_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/lesson.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/dialog_sumbit_button.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CreateLessonDialog extends StatefulWidget {
  const CreateLessonDialog({this.parentId, this.courseId, key})
      : super(key: key);

  final String parentId, courseId;
  @override
  _CreateLessonDialogState createState() => _CreateLessonDialogState();
}

class _CreateLessonDialogState extends State<CreateLessonDialog> {
  CreateLessonForm _form;

  @override
  void initState() {
    super.initState();

    _form = CreateLessonForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              // DialogFormField(
              //   onChanged: (value) => _form.Summary = value,
              //   label: 'ملخص',
              // ),
              DialogFormField(
                onChanged: (value) => _form.paymentNote = value,
                label: 'ملاحظات عن الدفع',
              ),
              Spacer(),
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
    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.courseId}/lessons',
      method: HttpMethod.POST,
      headers: ConstDataHelper.apiCommonHeaders,
      body: jsonEncode(_form.toMap()),
    );

    if (result is Ok) {
      var outcome = jsonDecode(result.body)['outcome'];

      Lesson lesson = Lesson.fromMap(outcome);
      print(lesson.id);
      Provider.of<ParentsProvider>(context, listen: false)
          .addLesson(widget.parentId, widget.courseId, lesson);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إضافة الدرس بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to add lesson');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء إضافة الدرس',
      );
    }
  }
}

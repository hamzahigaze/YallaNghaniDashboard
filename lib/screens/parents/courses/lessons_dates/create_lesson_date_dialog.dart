import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/parents/courses/lessons_dates/create_lesson_date_from.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/lessons_dates/Day.dart';
import 'package:yalla_dashboard/models/lessons_dates/lesson_date.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/dialog_sumbit_button.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CreateLessonDateDialog extends StatefulWidget {
  const CreateLessonDateDialog({this.parentId, this.courseId, key})
      : super(key: key);

  final String parentId, courseId;
  @override
  _CreateLessonDateDialogState createState() => _CreateLessonDateDialogState();
}

class _CreateLessonDateDialogState extends State<CreateLessonDateDialog> {
  CreateLessonDateForm _form;

  @override
  void initState() {
    super.initState();

    _form = CreateLessonDateForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 300,
                child: DropdownButton<Day>(
                  value: _form.day,
                  onChanged: (value) {
                    setState(() {
                      _form.day = value;
                    });
                  },
                  items: [
                    ...Day.values.map(
                      (day) => DropdownMenuItem<Day>(
                        value: day,
                        child: Text(day.toArabic()),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              DialogFormField(
                onChanged: (value) => _form.hour = value,
                label: 'الساعة',
                textDirection: TextDirection.ltr,
              ),
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

    if (!_form.isValidHourFormat()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء إدخال قيمة صحيحة في حقل الساعة من الصيغة hh.mm',
      );

      return;
    }

    print(_form.toMap());

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.courseId}/lessonsdates',
      method: HttpMethod.POST,
      headers: ConstDataHelper.apiCommonHeaders,
      body: jsonEncode(_form.toMap()),
    );

    if (result is Ok) {
      var outcome = jsonDecode(result.body)['outcome'];

      LessonDate lessonDate = LessonDate.fromMap(outcome);

      Provider.of<ParentsProvider>(context, listen: false)
          .addLessonDate(widget.parentId, widget.courseId, lessonDate);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إضافة الموعد بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to add lesson');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء إضافة الموعد',
      );
    }
  }
}

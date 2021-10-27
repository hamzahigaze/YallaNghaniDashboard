import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/parents/courses/edit_course_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/course.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/dialog_sumbit_button.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class EditCourseDialog extends StatefulWidget {
  const EditCourseDialog({this.parentId, this.course, Key key})
      : super(key: key);

  final Course course;
  final String parentId;
  @override
  _EditCourseDialogState createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<EditCourseDialog> {
  EditCourseForm _form;

  @override
  void initState() {
    super.initState();

    _form = EditCourseForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                initialValue: widget.course.studentName,
                label: 'اسم الطالب',
                onChanged: (value) => _form.studentName = value,
              ),
              Spacer(),
              DialogFormField(
                initialValue: widget.course.title,
                label: 'اسم الدورة',
                onChanged: (value) => _form.title = value,
              ),
            ],
          ),
          Row(
            children: [
              DialogFormField(
                initialValue: widget.course.lessonFee.toString(),
                label: 'تكلفة الدرس',
                onChanged: (value) => _form.lessonFee = value,
              ),
              Spacer(),
            ],
          ),
          DialogSubmitButton(
            text: 'حفظ التعديلات',
            onPressed: _submit,
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

    if (_form.lessonFee != null && !_form.isDoubleLessonFee()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء إدخال قيمة صحيحة في حقل التكلفة',
      );

      return;
    }

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.course.id}',
      method: HttpMethod.PUT,
      body: jsonEncode(_form.toMap()),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Updated Course Successfully');

      if (_form.title != null) widget.course.title = _form.title;

      if (_form.lessonFee != null)
        widget.course.lessonFee = _form.lessonFeeNumericValue;

      if (_form.studentName != null)
        widget.course.studentName = _form.studentName;

      Provider.of<ParentsProvider>(context, listen: false).notifyChanges();

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم تحديث الدورة بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to update course');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء تعديل المعلومات',
      );
    }
  }
}

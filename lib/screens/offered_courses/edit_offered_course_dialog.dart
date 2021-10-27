import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/offered_courses/edit_offered_course_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/offered_courses/offered_course.dart';
import 'package:yalla_dashboard/providers/offered_courses_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class EditOfferedCourseDialog extends StatefulWidget {
  const EditOfferedCourseDialog({this.course, Key key}) : super(key: key);

  final OfferedCourse course;
  @override
  _EditOfferedCourseDialogState createState() =>
      _EditOfferedCourseDialogState();
}

class _EditOfferedCourseDialogState extends State<EditOfferedCourseDialog> {
  EditOfferedCourseForm _form;

  @override
  void initState() {
    super.initState();
    _form = EditOfferedCourseForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                initialValue: widget.course.title,
                onChanged: (value) {
                  _form.title = value;
                },
                label: 'عنوان الدورة',
              ),
              Spacer(),
              DialogFormField(
                initialValue: widget.course.teacherName,
                onChanged: (value) {
                  _form.teacherName = value;
                },
                label: 'اسم المعلم',
              ),
            ],
          ),
          Row(
            children: [
              DialogFormField(
                initialValue: widget.course.description,
                onChanged: (value) {
                  _form.description = value;
                },
                label: 'وصف الدورة',
                maxLines: 5,
              ),
              Spacer(),
              DialogFormField(
                initialValue: widget.course.teacherDescription,
                onChanged: (value) {
                  _form.teacherDescription = value;
                },
                label: 'وصف المعلم',
                maxLines: 5,
              ),
            ],
          ),
          Row(
            children: [
              DialogFormField(
                initialValue: widget.course.imageUrl,
                onChanged: (value) => _form.imageUrl = value,
                label: 'رابط الصورة',
                textDirection: TextDirection.ltr,
              ),
              SizedBox(width: 80),
              Expanded(
                child: Row(
                  children: [
                    Text('علاجية :'),
                    Switch(
                      value: _form.isEducational != null
                          ? !_form.isEducational
                          : !widget.course.isEducational,
                      onChanged: (value) {
                        setState(() {
                          _form.isEducational = !value;
                        });
                      },
                    )
                  ],
                ),
              )
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
                child: Text('حفظ'),
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

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/offeredcourses/${widget.course.id}',
      method: HttpMethod.PUT,
      body: jsonEncode(_form.toMap()),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Upated offered course successfully');

      var map = jsonDecode(result.body)['outcome'];

      OfferedCourse offeredCourse = OfferedCourse.fromMap(map);

      print(offeredCourse);

      Provider.of<OfferedCoursesProvider>(context, listen: false)
          .updateCourse(offeredCourse);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم تعديل الدورة بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to update offered course');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء تعديل الدورة',
      );
    }
  }
}

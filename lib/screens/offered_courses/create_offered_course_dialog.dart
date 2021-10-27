import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/forms/offered_courses/create_offered_course_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/offered_courses/offered_course.dart';
import 'package:yalla_dashboard/providers/offered_courses_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CreateOfferedCourseDialog extends StatefulWidget {
  const CreateOfferedCourseDialog({Key key}) : super(key: key);

  @override
  _CreateOfferedCourseDialogState createState() =>
      _CreateOfferedCourseDialogState();
}

class _CreateOfferedCourseDialogState extends State<CreateOfferedCourseDialog> {
  CreateOfferedCourseForm _form;
  List<String> teachers;

  @override
  void initState() {
    super.initState();

    _fetchTeachers();
    _form = CreateOfferedCourseForm();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                onChanged: (value) {
                  _form.title = value;
                },
                label: 'عنوان الدورة',
              ),
              Spacer(),
              Container(
                width: 300,
                child: DropdownButton<String>(
                  value: _form.teacherName,
                  onChanged: (value) {
                    setState(() {
                      _form.teacherName = value;
                    });
                  },
                  items: [
                    if (teachers != null)
                      for (var teacher in teachers)
                        DropdownMenuItem<String>(
                          child: Text(teacher),
                          value: teacher,
                        )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              DialogFormField(
                onChanged: (value) {
                  _form.description = value;
                },
                label: 'وصف الدورة',
                maxLines: 5,
              ),
              Spacer(),
              DialogFormField(
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
                      value: !_form.isEducational,
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

  Future<void> _fetchTeachers() async {
    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/teachers',
      method: HttpMethod.GET,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Succeeded fetching teachers names');

      var teachersData = jsonDecode(result.body)['outcome']['items'];

      teachers = teachersData
          .map<String>((t) => '${t['firstName']} ${t['lastName']}')
          .toList();

      _form.teacherName = teachers[0];
    } else {
      print('Failed fetching teachers names');
      print(result);

      teachers = null;
    }
    setState(() {});
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
      url: '${ConstDataHelper.baseUrl}/offeredcourses',
      method: HttpMethod.POST,
      body: jsonEncode(_form.toMap()),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Created offered course successfully');

      var map = jsonDecode(result.body)['outcome'];

      OfferedCourse offeredCourse = OfferedCourse.fromMap(map);

      Provider.of<OfferedCoursesProvider>(context, listen: false)
          .addCourse(offeredCourse);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إنشاء الدورة بنجاح',
        (_) => Navigator.of(context).pop(),
      );
    } else {
      print('Failed to add offered course');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء إنشاء الحساب',
      );
    }
  }
}

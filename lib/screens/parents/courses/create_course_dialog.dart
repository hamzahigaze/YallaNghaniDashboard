import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/offered_courses/offered_courses_cubit.dart';
import 'package:yalla_dashboard/cubits/parents/parents_cubit.dart';
import 'package:yalla_dashboard/forms/parents/courses/create_course_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/course.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CreateCourseDialog extends StatefulWidget {
  const CreateCourseDialog({this.parentId, key}) : super(key: key);

  final String parentId;
  @override
  _CreateCourseDialogState createState() => _CreateCourseDialogState();
}

class _CreateCourseDialogState extends State<CreateCourseDialog> {
  CreateCourseForm _form;
  List<Map<String, String>> teachers;
  List<String> coursesNames;

  @override
  void initState() {
    super.initState();

    _form = CreateCourseForm();
    _fetchTeachers();
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) async {
      coursesNames = await BlocProvider.of<OfferedCoursesCubit>(context)
          .fetchCoursesNames();
      _form.title = coursesNames[0];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            children: [
              DialogFormField(
                label: 'اسم الطالب',
                onChanged: (value) => _form.studentName = value,
              ),
              Spacer(),
              Container(
                width: 300,
                child: DropdownButton<String>(
                  value: _form.title,
                  items: [
                    if (coursesNames != null)
                      for (var name in coursesNames)
                        DropdownMenuItem(
                          child: Text(name),
                          value: name,
                        )
                  ],
                  onChanged: (value) {
                    setState(() {
                      _form.title = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 300,
                child: DropdownButton<String>(
                  value: _form.teacherId,
                  onChanged: (value) {
                    setState(() {
                      _form.teacherId = value;
                    });
                  },
                  items: [
                    if (teachers != null)
                      for (var teacher in teachers)
                        DropdownMenuItem<String>(
                          child: Text(teacher['name']),
                          value: teacher['id'],
                        )
                  ],
                ),
              ),
              Spacer(),
              DialogFormField(
                label: 'تكلفة الدرس',
                onChanged: (value) => _form.lessonFee = value,
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
          ElevatedButton(
            child: Text('إنشاء'),
            onPressed: _submit,
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
      print('Succeeded fetching teachers names and ids');

      var teachersData = jsonDecode(result.body)['outcome']['items'];

      teachers = teachersData
          .map<Map<String, String>>(
            (t) => <String, String>{
              'name': '${t['firstName']} ${t['lastName']}',
              'id': t['id'],
            },
          )
          .toList();

      _form.teacherId = teachers[0]['id'];
    } else {
      print('Failed fetching teachers names and ids ');
      print(result);

      teachers = null;
    }
    setState(() {});
  }

  // Future<void> _fetchCoursesNames() async {
  //   var result = await ApiCaller.request(
  //     url: '${ConstDataHelper.baseUrl}/offeredcourses',
  //     method: HttpMethod.GET,
  //     headers: ConstDataHelper.apiCommonHeaders,
  //   );

  //   if (result is Ok) {
  //     print('Succeeded fetching courses names');

  //     var coursesData = jsonDecode(result.body)['outcome'];

  //     coursesNames = coursesData.map<String>((t) {
  //       return t['title'] as String;
  //     }).toList();

  //     _form.title = coursesNames[0];
  //   } else {
  //     print('Failed fetching courses names ');
  //     print(result);

  //     coursesNames = null;
  //   }
  //   setState(() {});
  // }

  void _submit() async {
    if (_form.hasEmptyFields()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        ConstDataHelper.emptyFieldsError,
      );

      return;
    }

    if (!_form.isDoubleLessonFee()) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء إدخال قيمة صحيحة في حقل تكلفة الدرس',
      );

      return;
    }

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses',
      method: HttpMethod.POST,
      headers: ConstDataHelper.apiCommonHeaders,
      body: jsonEncode(_form.toMap()),
    );

    if (result is Ok) {
      print('Successfully created the course');

      var outcome = jsonDecode(result.body)['outcome'];

      var course = Course.fromMap(outcome);

      Provider.of<ParentsProvider>(context, listen: false)
          .addCourse(widget.parentId, course);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم إنشاء الدورة بنجاح',
        (_) => Navigator.of(context).pop(),
      );

      return;
    }

    print('Failed Creating the course');
    print(result);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'حدث خطأ أثناء إنشاء الدورة',
    );
  }
}

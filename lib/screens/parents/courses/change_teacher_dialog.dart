import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_dashboard/cubits/parents/parents_cubit.dart';
import 'package:yalla_dashboard/forms/parents/courses/create_course_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';

class ChangeTeacherDialog extends StatefulWidget {
  const ChangeTeacherDialog({this.parentId, this.courseId, this.teacherId, key})
      : super(key: key);

  final String parentId, courseId, teacherId;
  @override
  _ChangeTeacherDialogState createState() => _ChangeTeacherDialogState();
}

class _ChangeTeacherDialogState extends State<ChangeTeacherDialog> {
  CreateCourseForm _form;
  List<Map<String, String>> teachers;
  String newTeacherId, previousTeacherId;

  @override
  void initState() {
    super.initState();
    _form = CreateCourseForm();
    previousTeacherId = widget.teacherId;
    _fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 300,
                child: DropdownButton<String>(
                  value: newTeacherId ?? previousTeacherId,
                  onChanged: (value) {
                    setState(() {
                      newTeacherId = value;
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
            ],
          ),
          ElevatedButton(
            child: Text('تعديل'),
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

  void _submit() async {
    if (newTeacherId == null || previousTeacherId == newTeacherId) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء اختيار معلم غير المعلم الحالي للدورة',
      );

      return;
    }

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.courseId}/changeteacher',
      method: HttpMethod.PUT,
      headers: ConstDataHelper.apiCommonHeaders,
      body: jsonEncode({'newTeacherId': newTeacherId}),
    );

    if (result is Ok) {
      print('Successfully updated the teacher');

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم تغيير المعلم بنجاح',
        (_) {
          Navigator.of(context).pop();
          BlocProvider.of<ParentsCubit>(context).fetchParents();
        },
      );

      return;
    }

    print('Failed to update the teacher');
    print(result);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'حدث خطأ أثناء تغيير المعلم',
    );
  }
}

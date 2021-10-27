import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/offered_courses/offered_courses_cubit.dart';
import 'package:yalla_dashboard/cubits/parents/parents_cubit.dart';
import 'package:yalla_dashboard/forms/parents/messages/create_message_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class MessageByCourseDialog extends StatefulWidget {
  const MessageByCourseDialog({Key key}) : super(key: key);

  @override
  _MessageByCourseDialogState createState() => _MessageByCourseDialogState();
}

class _MessageByCourseDialogState extends State<MessageByCourseDialog> {
  List<String> coursesNames;
  String selectedCourseName;
  List<String> parentsIds;
  CreateMessageFrom _form;

  @override
  void initState() {
    super.initState();
    coursesNames = [];
    selectedCourseName = "";
    parentsIds = [];
    _form = CreateMessageFrom();
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) async {
      coursesNames = await BlocProvider.of<OfferedCoursesCubit>(context)
          .fetchCoursesNames();
      selectedCourseName = coursesNames[0];
      setState(() {});
    });
  }

  void _setParentsIds(String courseName) {
    parentsIds = Provider.of<ParentsProvider>(context, listen: false)
        .parents
        .where((p) => p.courses.any((e) => e.title == courseName))
        .map((e) => e.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: ListView(
        children: [
          DropdownButton<String>(
            items: <DropdownMenuItem<String>>[
              if (coursesNames != null)
                ...coursesNames.map(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  ),
                )
            ],
            value: selectedCourseName,
            onChanged: (value) {
              _setParentsIds(value);
              selectedCourseName = value;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
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

    await BlocProvider.of<ParentsCubit>(context)
        .sendMessageToParents(parentsIds, _form);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'تم إرسال الرسائل',
      (_) => Navigator.of(context).pop(),
    );
  }
}

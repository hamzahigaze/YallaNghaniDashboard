import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/parents/parents_cubit.dart';
import 'package:yalla_dashboard/forms/parents/messages/create_message_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/message.dart';
import 'package:yalla_dashboard/models/parents/parent.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/form_dialog_base.dart';
import 'package:yalla_dashboard/widgets/form_fields.dart/dialog_form_field.dart';

class CustomMessageDialog extends StatefulWidget {
  const CustomMessageDialog({Key key}) : super(key: key);

  @override
  _CustomMessageDialogState createState() => _CustomMessageDialogState();
}

class _CustomMessageDialogState extends State<CustomMessageDialog> {
  CreateMessageFrom _form;
  List<Parent> parentsList;
  List<String> selectedParentsIds;
  List<Map<String, dynamic>> parentsSelectionMap = [];
  bool selecteAllFlag;
  bool unselectAllFlag;
  @override
  void initState() {
    super.initState();
    _form = CreateMessageFrom()..date = DateTime.now().add(Duration(hours: 3));
    selectedParentsIds = [];
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ParentsProvider>(context, listen: false).parents.forEach((p) {
        parentsSelectionMap.add({
          'id': p.id,
          'name': p.firstName + ' ' + p.lastName,
          'selected': false
        });
      });
      parentsSelectionMap.sort((v1, v2) => v1['name'].compareTo(v2['name']));
    });
    selecteAllFlag = false;
    unselectAllFlag = false;
  }

  bool get _hasSelectedParents {
    bool hasSelected = false;
    for (var parentMap in parentsSelectionMap) {
      if (parentMap['selected'] == true) {
        hasSelected = true;
        break;
      }
    }
    return hasSelected;
  }

  @override
  Widget build(BuildContext context) {
    return FormDialogBase(
      child: ListView(
        children: [
          Row(
            children: [
              Text('إرسال إلى'),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  showSelectionDialog();
                },
                icon: Icon(Icons.add),
                color: Colors.blue,
              )
            ],
          ),
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

  void showSelectionDialog() {
    showDialog(
      context: context,
      builder: (context1) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context1, setStater) {
              return Dialog(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 250, vertical: 80),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'تحديد الكل',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 15),
                        Checkbox(
                            value: selecteAllFlag,
                            onChanged: (value) {
                              if (value == true) {
                                parentsSelectionMap.forEach((e) {
                                  e['selected'] = true;
                                });
                              } else {
                                parentsSelectionMap.forEach((e) {
                                  e['selected'] = false;
                                });
                              }
                              setStater(() {
                                selecteAllFlag = value;
                              });
                            }),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('تم'),
                        )
                      ],
                    ),
                    for (var p in parentsSelectionMap)
                      CheckboxListTile(
                        value: p['selected'],
                        onChanged: (value) {
                          setStater(
                            () {
                              p['selected'] = value;
                              if (value == false && selecteAllFlag == true) {
                                selecteAllFlag = false;
                              }
                            },
                          );
                        },
                        title: Text(p['name']),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
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

    if (!_hasSelectedParents) {
      UIHelper.showMessageDialogWithOkButton(
        context,
        'الرجاء تحديد مستخدم واحد على الأقل لإرسال الرسالة',
      );
      return;
    }

    var ids = parentsSelectionMap
        .where((e) => e['selected'])
        .map((e) => e['id'])
        .toList();

    await BlocProvider.of<ParentsCubit>(context)
        .sendMessageToParents(ids, _form);

    UIHelper.showMessageDialogWithOkButton(
      context,
      'تم إرسال الرسائل',
      (_) => Navigator.of(context).pop(),
    );
  }
}

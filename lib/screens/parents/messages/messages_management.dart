import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/message.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';

import 'create_message.dart';

class MessagesManagementScreen extends StatefulWidget {
  const MessagesManagementScreen({Key key, this.parentId, this.messages})
      : super(key: key);

  final String parentId;
  final List<Message> messages;
  @override
  _MessagesManagementScreenState createState() =>
      _MessagesManagementScreenState();
}

class _MessagesManagementScreenState extends State<MessagesManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الرسائل'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 100),
          children: [
            SizedBox(height: 20),
            Container(
              height: 100,
              width: 250,
              child: Image(
                image: AssetImage(
                  './assets/illustration/music/illu-3.png',
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('رسالة جديدة +'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CreateMessageDialog(
                          id: widget.parentId,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            _messagesView(),
          ],
        ),
      ),
    );
  }

  Widget _messagesView() {
    return Consumer<ParentsProvider>(
      builder: (_, __, ___) => SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('العنوان')),
            DataColumn(label: Text('النص')),
            DataColumn(label: Text('التاريخ')),
            DataColumn(label: Text('اسم المرسل')),
            DataColumn(label: Text('حذف الرسالة'))
          ],
          rows: [
            ...widget.messages.map(
              (message) => DataRow(
                cells: [
                  DataCell(Text(message.title)),
                  DataCell(
                    Container(
                      width: 300,
                      child: Text(message.content),
                    ),
                  ),
                  DataCell(
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(message.date),
                    ),
                  ),
                  DataCell(Text(message.senderName)),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _deleteMessage(message.id),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMessage(String id) async {
    var isSure =
        await UIHelper.showDeleteConfirmationDialog(context, 'الرسالة');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/messages/$id',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('message was deleted successfully');

      UIHelper.showMessageDialogWithOkButton(context, 'تم حذف الرسالة بنجاح');
      Provider.of<ParentsProvider>(context, listen: false)
          .removeMessage(widget.parentId, id);
    } else {
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء حذف الرسالة',
      );
    }
  }
}

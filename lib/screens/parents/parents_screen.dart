import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/parents/parents_cubit.dart';
import 'package:yalla_dashboard/models/parents/parent.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/screens/parents/courses/course_screen.dart';
import 'package:yalla_dashboard/screens/parents/courses/create_course_dialog.dart';
import 'package:yalla_dashboard/screens/parents/messages/custom_message_dialog.dart';
import 'package:yalla_dashboard/screens/parents/messages/message_by_course_dialog.dart';
import 'package:yalla_dashboard/screens/parents/messages/messages_management.dart';

import 'package:yalla_dashboard/widgets/drawers/side_menu.dart';

class ParentsScreen extends StatefulWidget {
  const ParentsScreen({Key key}) : super(key: key);

  @override
  _ParentsScreenState createState() => _ParentsScreenState();
}

class _ParentsScreenState extends State<ParentsScreen> {
  List<DataRow> parentsRows;

  @override
  void initState() {
    parentsRows = [];
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await BlocProvider.of<ParentsCubit>(context).fetchParents();
      addAllParents();
    });
  }

  void addParentRow(Parent parent) {
    parentsRows.add(
      DataRow(cells: [
        DataCell(Text(parent.firstName)),
        DataCell(Text(parent.lastName)),
        DataCell(Text(parent.phoneNumber)),
        DataCell(Text(parent.courses.length.toString())),
        DataCell(IconButton(
          icon: Icon(Icons.view_list_outlined),
          onPressed: () => _showCoursesList(parent),
          color: Colors.orangeAccent,
        )),
        DataCell(
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MessagesManagementScreen(
                    parentId: parent.id,
                    messages: parent.messages,
                  ),
                ),
              );
            },
            color: Colors.blueAccent,
          ),
        ),
      ]),
    );
  }

  void addAllParents() {
    parentsRows?.clear();
    Provider.of<ParentsProvider>(context, listen: false)
        .parents
        .forEach((element) {
      addParentRow(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('المستخدمين'),
        ),
        drawer: SideMenu(),
        body: BlocBuilder<ParentsCubit, ParentsState>(
          builder: (context, state) {
            if (state is ParentsCubitLoadInProgress ||
                state is ParentsCubitInitial)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is ParentsCubitSuccess) {
              return ListView(
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
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('إرسال رسالة الخاصة'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomMessageDialog();
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          child: Text('إرسال رسالة حسب الدورة'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return MessageByCourseDialog();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  _parentsView()
                ],
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حدث خطأ أثناء جلب البيانات الخاصة بالحسابات'),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ParentsCubit>(context).fetchParents();
                    },
                    child: Text('إعادة المحاولة'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _parentsView() {
    return Consumer<ParentsProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'عدد المستخدمين الكلي : ${provider.parents.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 25),
                Container(
                  width: 250,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'بحث حسب الاسم',
                    ),
                    initialValue: '',
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          parentsRows.clear();
                          addAllParents();
                        } else {
                          parentsRows.clear();
                          nameSearch(value).forEach((element) {
                            addParentRow(element);
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('الاسم الأول')),
                  DataColumn(label: Text('العائلة')),
                  DataColumn(label: Text('رقم الهاتف')),
                  DataColumn(label: Text('عدد الدورات المسجلة')),
                  DataColumn(label: Text('إدارة الدورات')),
                  DataColumn(label: Text('إدارة الرسائل')),
                ],
                rows: parentsRows,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCoursesList(Parent parent) {
    showDialog(
      context: context,
      builder: (innerContext) {
        return Consumer<ParentsProvider>(
          builder: (counsumerContext, providr, _) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...parent.courses.map(
                      (course) => Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CourseScreen(
                                  parentId: parent.id,
                                  course: course,
                                ),
                              ),
                            );
                          },
                          child:
                              Text('${course.title} - ${course.studentName}'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => CreateCourseDialog(
                            parentId: parent.id,
                          ),
                        );
                      },
                      child: Text('دورة جديدة +'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Parent> nameSearch(String value) {
    return Provider.of<ParentsProvider>(context, listen: false)
        .parents
        .where(
          (element) =>
              element.firstName.contains(value) ||
              element.lastName.contains(value),
        )
        .toList();
  }
}

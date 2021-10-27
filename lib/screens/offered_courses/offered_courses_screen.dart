import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/offered_courses/offered_courses_cubit.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/providers/offered_courses_provider.dart';
import 'package:yalla_dashboard/screens/offered_courses/edit_offered_course_dialog.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/drawers/side_menu.dart';

import 'create_offered_course_dialog.dart';

class OfferedCoursesScreen extends StatefulWidget {
  const OfferedCoursesScreen({Key key}) : super(key: key);

  @override
  _OfferedCoursesScreenState createState() => _OfferedCoursesScreenState();
}

class _OfferedCoursesScreenState extends State<OfferedCoursesScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<OfferedCoursesCubit>(context).fetchOfferedCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الدورات'),
        ),
        drawer: SideMenu(),
        body: BlocBuilder<OfferedCoursesCubit, OfferedCoursesState>(
          builder: (context, state) {
            if (state is OfferedCoursesLoadInProgress ||
                state is OfferedCoursesInitial)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is OfferedCoursesSuccess)
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text('إنشاء دورة جديدة +'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CreateOfferedCourseDialog();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  _coursesView()
                ],
              );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حدث خطأ أثناء جلب البيانات الخاصة بالدورات'),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<OfferedCoursesCubit>(context)
                          .fetchOfferedCourses();
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

  Widget _coursesView() {
    return Consumer<OfferedCoursesProvider>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'عدد الدورات الكلي : ${provider.courses.length}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('عنوان الدورة')),
                DataColumn(label: Text('الوصف')),
                DataColumn(label: Text('اسم المعلم')),
                DataColumn(label: Text('عن المعلم')),
                DataColumn(label: Text('تعليمية أو علاجية')),
                DataColumn(label: Text('تعديل البيانات')),
                DataColumn(label: Text('حذف الدورة')),
              ],
              rows: [
                ...provider.courses.map(
                  (course) => DataRow(cells: [
                    DataCell(Text(course.title)),
                    DataCell(
                      Container(
                        height: 120,
                        width: 200,
                        child: Text(
                          course.description,
                        ),
                      ),
                    ),
                    DataCell(Text(course.teacherName)),
                    DataCell(
                      Container(
                        height: 120,
                        width: 200,
                        child: Text(
                          course.teacherDescription,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    DataCell(Text(course.isEducational ? 'تعليمية' : 'علاجية')),
                    DataCell(IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              EditOfferedCourseDialog(course: course),
                        );
                      },
                      color: Colors.amberAccent,
                    )),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCourse(course.id),
                      color: Colors.red,
                    )),
                  ]),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  void _deleteCourse(String id) async {
    //

    var isSure = await UIHelper.showDeleteConfirmationDialog(context, 'الدورة');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/offeredcourses/$id',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Deleted offered course successfully');

      UIHelper.showMessageDialogWithOkButton(
        context,
        'تم حذف الدورة بنجاح',
      );

      Provider.of<OfferedCoursesProvider>(context, listen: false)
          .deleteCourse(id);
    } else {
      print('Failed to delete offered course');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        'حدث خطأ أثناء حذف الدورة',
      );
    }
  }
}

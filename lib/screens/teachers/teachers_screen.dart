import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/cubits/teachers/teachers_cubit.dart';

import 'package:yalla_dashboard/providers/teachers_provider.dart';

import 'package:yalla_dashboard/screens/teachers/lessons_dates_screen.dart';
import 'package:yalla_dashboard/widgets/drawers/side_menu.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key key}) : super(key: key);

  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TeachersCubit>(context).fetchTeachers();
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
        body: BlocBuilder<TeachersCubit, TeachersState>(
          builder: (context, state) {
            if (state is TeachersLoadInProgress || state is TeachersInitial)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is TeachersSuccess)
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
                  _teachersView()
                ],
              );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('حدث خطأ أثناء جلب البيانات الخاصة بالمعلمين'),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TeachersCubit>(context).fetchTeachers();
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

  Widget _teachersView() {
    return Consumer<TeachersProvider>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'عدد المعلمين الكلي : ${provider.teachers.length}',
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
                DataColumn(label: Text('الاسم الأول')),
                DataColumn(label: Text('العائلة')),
                DataColumn(label: Text('رقم الهاتف')),
                DataColumn(label: Text('المواعيد')),
              ],
              rows: [
                ...provider.teachers.map(
                  (teacher) => DataRow(cells: [
                    DataCell(Text(teacher.firstName)),
                    DataCell(
                      Text(teacher.lastName),
                    ),
                    DataCell(Text(teacher.phoneNumber)),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.view_list_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LessonsDatesScreen(
                                teacher: teacher,
                              ),
                            ),
                          );
                        },
                        color: Colors.amberAccent,
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}

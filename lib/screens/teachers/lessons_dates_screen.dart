import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/models/lessons_dates/Day.dart';
import 'package:yalla_dashboard/models/lessons_dates/lesson_date.dart';
import 'package:yalla_dashboard/models/teachers/teacher.dart';
import 'package:yalla_dashboard/providers/teachers_provider.dart';

class LessonsDatesScreen extends StatefulWidget {
  const LessonsDatesScreen({this.teacher, key}) : super(key: key);

  final Teacher teacher;
  @override
  _LessonsDatesScreenState createState() => _LessonsDatesScreenState();
}

class _LessonsDatesScreenState extends State<LessonsDatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
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
            _titleView('المواعيد'),
            _lessonDatesView()
          ],
        ),
      ),
    );
  }

  Widget _titleView(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _lessonDatesView() {
    List<Map<String, dynamic>> data = [];
    for (var course in widget.teacher.courses)
      for (var lessonDate in course.lessonsDates) {
        data.add({
          'studentName': course.studentName,
          'title': course.title,
          'lessonDate': lessonDate
        });
      }
    data.sort((l1, l2) => l1['lessonDate'].compareTo(l2['lessonDate']));
    return Consumer<TeachersProvider>(builder: (context, provider, _) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('الطالب')),
            DataColumn(label: Text('الدورة')),
            DataColumn(label: Text('اليوم')),
            DataColumn(label: Text('الساعة')),
          ],
          rows: [
            for (var d in data)
              DataRow(cells: [
                DataCell(Text(d['studentName'])),
                DataCell(Text(d['title'])),
                DataCell(Text((d['lessonDate'].day as Day).toArabic())),
                DataCell(Text(d['lessonDate'].hour)),
              ])
          ],
        ),
      );
    });
  }
}

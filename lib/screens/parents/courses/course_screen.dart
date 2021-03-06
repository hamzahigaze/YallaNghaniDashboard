import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/models/parents/course.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/models/parents/lesson.dart';
import 'package:yalla_dashboard/models/lessons_dates/Day.dart';
import 'package:yalla_dashboard/screens/parents/courses/change_teacher_dialog.dart';
import 'package:yalla_dashboard/screens/parents/courses/edit_course_dialog.dart';
import 'package:yalla_dashboard/screens/parents/courses/lessons/create_lesson_dialog.dart';
import 'package:yalla_dashboard/screens/parents/courses/lessons/edit_lesson_dialog.dart';
import 'package:yalla_dashboard/screens/parents/courses/lessons_dates/create_lesson_date_dialog.dart';
import 'package:yalla_dashboard/screens/parents/courses/payments/create_payment_dialog.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/widgets/dialogs/dialog_sumbit_button.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key key, this.course, this.parentId}) : super(key: key);

  final Course course;
  final String parentId;
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
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
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: _deleteCourse,
                    child: Text('?????? ????????????'),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
                    child: Text('?????????? ????????????'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ChangeTeacherDialog(
                          parentId: widget.parentId,
                          courseId: widget.course.id,
                          teacherId: widget.course.teacherId,
                        ),
                      );
                    },
                  ),
                ),
                Spacer()
              ],
            ),
            _titleView('?????????????? ????????'),
            _generalInfoView(),
            SizedBox(height: 30),
            Row(
              children: [
                _titleView('??????????????'),
                SizedBox(width: 25),
                DialogSubmitButton(
                  text: '???????? ??????????',
                  width: 150,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => CreaetPaymentDialog(
                      parentId: widget.parentId,
                      courseId: widget.course.id,
                    ),
                  ),
                )
              ],
            ),
            _paymentsView(),
            SizedBox(height: 30),
            Row(
              children: [
                _titleView('????????????'),
                DialogSubmitButton(
                  text: '?????? ????????',
                  width: 150,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => CreateLessonDialog(
                      parentId: widget.parentId,
                      courseId: widget.course.id,
                    ),
                  ),
                )
              ],
            ),
            _lessonsView(),
            SizedBox(height: 30),
            Row(
              children: [
                _titleView('????????????????'),
                DialogSubmitButton(
                  text: '???????? ????????',
                  width: 150,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => CreateLessonDateDialog(
                      parentId: widget.parentId,
                      courseId: widget.course.id,
                    ),
                  ),
                )
              ],
            ),
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

  Widget _generalInfoView() {
    return Consumer<ParentsProvider>(builder: (_, provider, __) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('????????????')),
            DataColumn(label: Text('????????????')),
            DataColumn(label: Text('????????????')),
            DataColumn(label: Text('?????????? ??????????')),
            DataColumn(label: Text('????????????')),
            DataColumn(label: Text('??????????')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text(widget.course.studentName)),
              DataCell(Text(widget.course.title)),
              DataCell(Text(widget.course.teacherName)),
              DataCell(Text(widget.course.lessonFee.toString())),
              DataCell(Text(widget.course.parentBalance.toString())),
              DataCell(
                IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  color: Colors.orangeAccent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditCourseDialog(
                        course: widget.course,
                        parentId: widget.parentId,
                      ),
                    );
                  },
                ),
              ),
            ])
          ],
        ),
      );
    });
  }

  Widget _paymentsView() {
    return Consumer<ParentsProvider>(builder: (_, provider, __) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('?????????? ??????????')),
            DataColumn(label: Text('??????????????')),
            DataColumn(label: Text('????????????')),
            DataColumn(label: Text('?????? ????????????')),
          ],
          rows: [
            ...widget.course.payments.map(
              (payment) => DataRow(cells: [
                DataCell(Text(payment.paymentMethod)),
                DataCell(Text(payment.date)),
                DataCell(Text(payment.amount.toString())),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deletePayment(payment.id),
                    color: Colors.red,
                  ),
                )
              ]),
            )
          ],
        ),
      );
    });
  }

  Widget _lessonsView() {
    return Consumer<ParentsProvider>(builder: (_, provider, __) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('??????????')),
            DataColumn(label: Text('??????????????')),
            DataColumn(label: Text('??????????????')),
            DataColumn(label: Text('???????? ??????????')),
            DataColumn(label: Text('?????????????? ???? ??????????')),
            DataColumn(label: Text('??????????')),
            DataColumn(label: Text('?????????? ?? ??????????')),
            DataColumn(label: Text('??????')),
          ],
          rows: [
            ...widget.course.lessons.reversed.map(
              (lesson) {
                var isPaied = lesson.paymentStatus == PaymentStatus.paied;
                var hasNote =
                    lesson.paymentNote != null && lesson.paymentNote.isNotEmpty;
                return DataRow(cells: [
                  DataCell(Text(lesson.number.toString())),
                  DataCell(Text(lesson.date)),
                  DataCell(Text(lesson.fee.toString())),
                  DataCell(Text(
                    lesson.paymentStatus.toArabic(),
                    style: TextStyle(
                      color: isPaied ? Colors.green : Colors.red,
                    ),
                  )),
                  DataCell(Text(hasNote ? lesson.paymentNote : '???? ????????')),
                  DataCell(IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EditLessonDialog(
                            courseId: widget.course.id,
                            parentId: widget.parentId,
                            lesson: lesson,
                          );
                        },
                      );
                    },
                    color: Colors.orangeAccent,
                  )),
                  DataCell(IconButton(
                    icon: Icon(Icons.payment),
                    onPressed:
                        isPaied ? null : () => _markLessonAsPaied(lesson),
                    color: Colors.green,
                  )),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteLesson(lesson.id),
                    color: Colors.red,
                  ))
                ]);
              },
            )
          ],
        ),
      );
    });
  }

  Widget _lessonDatesView() {
    return Consumer<ParentsProvider>(builder: (_, provider, __) {
      var course = provider.getCourse(widget.parentId, widget.course.id);
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('??????????')),
            DataColumn(label: Text('????????????')),
            DataColumn(label: Text('?????? ????????????')),
          ],
          rows: [
            ...course.lessonsDates.map((lessonDate) => DataRow(
                  cells: [
                    DataCell(Text(lessonDate.day.toArabic())),
                    DataCell(Text(lessonDate.hour)),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteLessonDate(lessonDate.id),
                      color: Colors.red,
                    ))
                  ],
                ))
          ],
        ),
      );
    });
  }

  void _deleteCourse() async {
    var isSure = await UIHelper.showDeleteConfirmationDialog(context, '????????????');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.course.id}',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Deleted course successfully');

      await UIHelper.showMessageDialogWithOkButton(
        context,
        '???? ?????? ???????????? ??????????',
      );

      Navigator.of(context).pop();

      Provider.of<ParentsProvider>(context, listen: false)
          .removeCourse(widget.parentId, widget.course.id);
    } else {
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        '?????? ?????? ?????????? ?????? ????????????',
      );
    }
  }

  void _deletePayment(String paymentId) async {
    var isSure = await UIHelper.showDeleteConfirmationDialog(context, '????????????');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.course.id}/payments/$paymentId',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Deleted payment successfully');

      UIHelper.showMessageDialogWithOkButton(
        context,
        '???? ?????? ???????????? ??????????',
      );

      Provider.of<ParentsProvider>(context, listen: false)
          .removePayment(widget.parentId, widget.course.id, paymentId);
    } else {
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        '?????? ?????? ?????????? ?????? ????????????',
      );
    }
  }

  void _markLessonAsPaied(Lesson lesson) async {
    var isSure = await UIHelper.showConfirmationDialog(
      context,
      '???? ?????? ?????????? ???? ?????????? ???????? ?????????? ??????????',
    );

    if (!isSure) return;

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.course.id}/lessons/${lesson.id}/pay',
      method: HttpMethod.PUT,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Updated payment status successfully');

      UIHelper.showMessageDialogWithOkButton(
        context,
        '???? ??????????????  ??????????',
      );

      lesson.paymentStatus = PaymentStatus.paied;
      widget.course.parentBalance -= lesson.fee;

      Provider.of<ParentsProvider>(context, listen: false).notifyChanges();
    } else {
      print('Failed to update payment status');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        '?????? ?????? ?????????? ?????????????? ',
      );
    }
  }

  void _deleteLesson(String lessonId) async {
    var isSure = await UIHelper.showDeleteConfirmationDialog(context, '??????????');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.course.id}/lessons/$lessonId',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Deleted Lesson successfully');

      UIHelper.showMessageDialogWithOkButton(
        context,
        '???? ?????? ??????????  ??????????',
      );

      Provider.of<ParentsProvider>(context, listen: false)
          .removeLesson(widget.parentId, widget.course.id, lessonId);
    } else {
      print('Failed to delete lesson');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        '?????? ?????? ?????????? ?????? ??????????',
      );
    }
  }

  void _deleteLessonDate(String lessonDateId) async {
    var isSure = await UIHelper.showDeleteConfirmationDialog(context, '????????????');

    if (!isSure) return;

    var result = await ApiCaller.request(
      url:
          '${ConstDataHelper.baseUrl}/parents/${widget.parentId}/courses/${widget.course.id}/lessonsdates/$lessonDateId',
      method: HttpMethod.DELETE,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Deleted lesson\'s date successfully');

      UIHelper.showMessageDialogWithOkButton(
        context,
        '???? ?????? ????????????  ??????????',
      );

      Provider.of<ParentsProvider>(context, listen: false)
          .removeLessonDate(widget.parentId, widget.course.id, lessonDateId);
    } else {
      print('Failed to delete lesson\'s date');
      print(result);

      UIHelper.showMessageDialogWithOkButton(
        context,
        '?????? ?????? ?????????? ?????? ???????????? ',
      );
    }
  }
}

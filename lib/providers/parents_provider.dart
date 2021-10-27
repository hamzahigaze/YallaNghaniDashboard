import 'package:flutter/cupertino.dart';
import 'package:yalla_dashboard/models/parents/course.dart';
import 'package:yalla_dashboard/models/parents/lesson.dart';
import 'package:yalla_dashboard/models/lessons_dates/lesson_date.dart';
import 'package:yalla_dashboard/models/parents/message.dart';
import 'package:yalla_dashboard/models/parents/parent.dart';
import 'package:yalla_dashboard/models/parents/payment.dart';

class ParentsProvider extends ChangeNotifier {
  List<Parent> _parents = [];

  void setParents(Iterable<Parent> parents) {
    _parents.clear();

    _parents.addAll(parents);
    _parents.sort((p1, p2) => p1.firstName.compareTo(p2.firstName));
    notifyListeners();
  }

  void addMessage(String id, Message message) {
    _parents.firstWhere((element) => element.id == id).messages.add(message);

    notifyListeners();
  }

  void removeMessage(String parentId, String messageId) {
    _parents
        .firstWhere((element) => element.id == parentId)
        .messages
        .removeWhere((element) => element.id == messageId);

    notifyListeners();
  }

  Course getCourse(String parentId, String courseId) {
    return _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId);
  }

  void addCourse(String parentId, Course course) {
    _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .add(course);

    notifyListeners();
  }

  void updateCourseTeacher(
      String parentId, String courseId, String newTeacherId) {
    _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId)
        .teacherId = newTeacherId;

    notifyListeners();
  }

  void removeCourse(String parentId, String courseId) {
    _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .removeWhere((element) => element.id == courseId);

    notifyListeners();
  }

  void addPayment(String parentId, String courseId, Payment payment) {
    var course = _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId);
    course.payments.add(payment);

    course.parentBalance += payment.amount;

    notifyListeners();
  }

  void removePayment(String parentId, String courseId, String paymentId) {
    var course = _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId);

    var payment =
        course.payments.firstWhere((element) => element.id == paymentId);

    course.parentBalance -= payment.amount;

    course.payments.remove(payment);

    notifyListeners();
  }

  void addLesson(String parentId, String courseId, Lesson lesson) {
    var course = _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId);

    course.lessons.add(lesson);

    notifyListeners();
  }

  void removeLesson(String parentId, String courseId, String lessonId) {
    var course = _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId);

    var lesson = course.lessons.firstWhere((element) => element.id == lessonId);

    course.lessons.remove(lesson);

    notifyListeners();
  }

  void addLessonDate(String parentId, String courseId, LessonDate lessonDate) {
    var course = _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId);

    course.lessonsDates.add(lessonDate);

    notifyListeners();
  }

  void removeLessonDate(String parentId, String courseId, String lessonDateId) {
    _parents
        .firstWhere((element) => element.id == parentId)
        .courses
        .firstWhere((element) => element.id == courseId)
        .lessonsDates
        .removeWhere((element) => element.id == lessonDateId);

    notifyListeners();
  }

  void notifyChanges() {
    notifyListeners();
  }

  List<Parent> get parents {
    List<Parent> parents = [..._parents];
    return parents;
  }
}

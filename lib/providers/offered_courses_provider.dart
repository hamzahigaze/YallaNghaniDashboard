import 'package:flutter/cupertino.dart';
import 'package:yalla_dashboard/models/offered_courses/offered_course.dart';

class OfferedCoursesProvider extends ChangeNotifier {
  List<OfferedCourse> _offeredCourses = [];

  void setCourses(Iterable<OfferedCourse> courses) {
    _offeredCourses.clear();
    _offeredCourses.addAll(courses);
  }

  void addCourse(OfferedCourse course) {
    _offeredCourses.add(course);

    notifyListeners();
  }

  void updateCourse(OfferedCourse course) {
    var index =
        _offeredCourses.indexWhere((element) => element.id == course.id);

    _offeredCourses[index] = course;

    notifyListeners();
  }

  void deleteCourse(String courseId) {
    _offeredCourses.removeWhere((element) => element.id == courseId);

    notifyListeners();
  }

  void notifyChanges() {
    notifyListeners();
  }

  List<OfferedCourse> get courses {
    return [..._offeredCourses];
  }
}

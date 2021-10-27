import 'package:flutter/cupertino.dart';
import 'package:yalla_dashboard/models/teachers/teacher.dart';

class TeachersProvider extends ChangeNotifier {
  List<Teacher> _teachers = [];

  void setTeachers(Iterable<Teacher> courses) {
    _teachers.clear();

    _teachers.addAll(courses);
    _teachers.sort((t1, t2) => t1.firstName.compareTo(t2.firstName));
    notifyListeners();
  }

  void notifyChanges() {
    notifyListeners();
  }

  List<Teacher> get teachers {
    return [..._teachers];
  }
}

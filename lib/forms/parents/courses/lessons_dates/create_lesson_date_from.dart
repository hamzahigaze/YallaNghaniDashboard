import 'package:yalla_dashboard/models/lessons_dates/Day.dart';

class CreateLessonDateForm {
  String hour = "";

  Day day = Day.sat;

  bool hasEmptyFields() {
    return hour != null && hour.isEmpty;
  }

  bool isValidHourFormat() {
    hour = hour.trim();

    if (hour.length != 5) return false;

    var dotIndex = hour.indexOf('.');

    if (dotIndex == -1) return false;

    var hourPart = hour.substring(0, dotIndex);
    var minutePart = hour.substring(dotIndex + 1, hour.length);

    if (hourPart.length != 2 && minutePart.length != 2) return false;

    int numMinute = int.tryParse(minutePart);
    int numHour = int.tryParse(hourPart);

    if (numMinute == null || numMinute < 0 || numMinute > 59) return false;

    if (numHour == null || numHour < 0 || numHour > 23) return false;

    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day.toString().substring(day.toString().indexOf('.') + 1),
      'hour': hour
    };
  }
}

import 'dart:convert';

import './Day.dart';

class LessonDate {
  Day day;

  String hour;

  String id;

  LessonDate({this.day, this.hour, this.id});

  LessonDate copyWith({
    Day day,
    String hour,
    String id,
  }) {
    return LessonDate(
        day: day ?? this.day, hour: hour ?? this.hour, id: id ?? this.id);
  }

  int get getHour {
    return int.parse(hour.substring(0, hour.indexOf('.')));
  }

  int get getMinute {
    return int.parse(hour.substring(hour.indexOf('.') + 1));
  }

  int compareTo(LessonDate obj) {
    if (obj.day.toDayNum() > day.toDayNum()) return -1;
    if (obj.day.toDayNum() < day.toDayNum()) return 1;
    if (obj.getHour > getHour) return -1;
    if (obj.getHour < getHour) return 1;
    if (obj.getMinute > getMinute) return -1;
    if (obj.getMinute < getMinute) return 1;
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day.toString().substring(day.toString().indexOf('.') + 1),
      'hour': hour,
      'id': id
    };
  }

  factory LessonDate.fromMap(Map<String, dynamic> map) {
    return LessonDate(
        day: DayExtension.fromString(map['day']),
        hour: map['hour'],
        id: map['id']);
  }

  String toJson() => json.encode(toMap());

  factory LessonDate.fromJson(String source) =>
      LessonDate.fromMap(json.decode(source));

  @override
  String toString() => 'LessonDate(day: $day, hour: $hour, id:$id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LessonDate && other.day == day && other.hour == hour;
  }

  @override
  int get hashCode => day.hashCode ^ hour.hashCode;
}

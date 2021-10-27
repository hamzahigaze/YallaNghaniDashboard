enum Day { sat, sun, mon, tue, wed, thu, fri }

extension DayExtension on Day {
  String toArabic() {
    switch (this) {
      case Day.sat:
        return 'السبت';
      case Day.sun:
        return "الأحد";
      case Day.mon:
        return "الإثنين";
      case Day.tue:
        return "الثلاثاء";
      case Day.wed:
        return "الأربعاء";
      case Day.thu:
        return "الخميس";
      case Day.fri:
        return "الجمعة";
    }
    return null;
  }

  static Day fromString(String day) {
    day = day.toLowerCase();
    if (day == 'sat')
      return Day.sat;
    else if (day == 'sun')
      return Day.sun;
    else if (day == 'mon')
      return Day.mon;
    else if (day == 'tue')
      return Day.tue;
    else if (day == 'wed')
      return Day.wed;
    else if (day == 'thu')
      return Day.thu;
    else if (day == 'fri') return Day.fri;

    return null;
  }

  static Day fromArabicString(String day) {
    if (day == 'السبت')
      return Day.sat;
    else if (day == 'الأحد')
      return Day.sun;
    else if (day == 'الإثنين')
      return Day.mon;
    else if (day == 'الثلاثاء')
      return Day.tue;
    else if (day == 'الأربعاء')
      return Day.wed;
    else if (day == 'الخميس')
      return Day.thu;
    else if (day == 'الجمعة') return Day.fri;

    return null;
  }

  int toDayNum() {
    switch (this) {
      case Day.sat:
        return DateTime.saturday;
      case Day.sun:
        return DateTime.sunday;
      case Day.mon:
        return DateTime.monday;
      case Day.tue:
        return DateTime.tuesday;
      case Day.wed:
        return DateTime.wednesday;
      case Day.thu:
        return DateTime.thursday;
      case Day.fri:
        return DateTime.friday;
    }
    return null;
  }
}

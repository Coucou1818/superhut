import 'package:superhut/utils/course/coursemain.dart';

/// Defines the real-world start and end times for each class section (1-10)
class ClassTimeTable {
  // Key: section number (1-10)
  // Value: [startHour, startMinute, endHour, endMinute]
  static const Map<int, List<int>> _times = {
    1: [8, 0, 8, 45],
    2: [8, 55, 9, 40],
    3: [10, 0, 10, 45],
    4: [10, 55, 11, 40],
    5: [14, 0, 14, 45],
    6: [14, 55, 15, 40],
    7: [16, 0, 16, 45],
    8: [16, 55, 17, 40],
    9: [19, 0, 19, 45],
    10: [19, 55, 20, 40],
  };

  /// Calculates the exact start and end DateTime for a Course on a specific base Date.
  ///
  /// [baseDate] The calendar date (e.g. today or sometime this week) the class falls on.
  /// [course] The course object containing startSection and duration.
  ///
  /// Returns a Map with 'start' and 'end' DateTime objects.
  static Map<String, DateTime> getCourseTimeRange(
    DateTime baseDate,
    Course course,
  ) {
    int startSec = course.startSection;
    int endSec = course.startSection + course.duration - 1;

    // Fallback if section is out of bounds
    if (!_times.containsKey(startSec)) {
      startSec = 1;
    }
    if (!_times.containsKey(endSec)) {
      endSec = startSec;
    }

    final startList = _times[startSec]!;
    final endList = _times[endSec]!;

    final startTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      startList[0],
      startList[1],
    );

    final endTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      endList[2],
      endList[3],
    );

    return {'start': startTime, 'end': endTime};
  }
}

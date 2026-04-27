import 'dart:async';
import 'package:flutter/services.dart';
import 'package:superhut/utils/course/coursemain.dart';
import 'package:superhut/utils/course/class_time_table.dart';
import 'package:permission_handler/permission_handler.dart';

/// Manages Android 16 Live Update notifications for class reminders.
class LiveNotificationManager {
  static const MethodChannel _channel = MethodChannel(
    'com.zhiquxy.rice/live_update',
  );

  /// Start a live notification manually (mostly for testing).
  static Future<void> showClassLiveUpdate({
    required String className,
    required String location,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      await _channel.invokeMethod('startClassLiveUpdate', {
        'className': className,
        'location': location,
        'startTimeMs': startTime.millisecondsSinceEpoch,
        'endTimeMs': endTime.millisecondsSinceEpoch,
      });
    } on PlatformException catch (e) {
      print("LiveNotification: post failed – ${e.message}");
    }
  }

  /// Cancel the active notification manually.
  static Future<void> stopClassLiveUpdate() async {
    try {
      await _channel.invokeMethod('stopClassLiveUpdate');
    } on PlatformException catch (e) {
      print("LiveNotification: failed to stop – ${e.message}");
    }
  }

  /// Sync the entire weekly schedule to Native so AlarmManager can handle backgrounds automatically.
  ///
  /// The [schedule] parameter maps date strings "yyyy-MM-dd" to lists of [Course] for that day.
  static Future<void> syncSchedule(Map<String, List<Course>> schedule) async {
    // Android 13+ requires explicit runtime permission for notifications
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }

    List<Map<String, dynamic>> nativePayload = [];

    schedule.forEach((dateString, courses) {
      try {
        final baseDate = DateTime.parse(dateString);
        for (var course in courses) {
          final range = ClassTimeTable.getCourseTimeRange(baseDate, course);
          nativePayload.add({
            'className': course.name,
            'location': course.location,
            'startTimeMs': range['start']!.millisecondsSinceEpoch,
            'endTimeMs': range['end']!.millisecondsSinceEpoch,
          });
        }
      } catch (e) {
        print('Error parsing date for class schedule sync: $e');
      }
    });

    try {
      // Send array of classes to native
      await _channel.invokeMethod('syncSchedule', {'classes': nativePayload});
    } on PlatformException catch (e) {
      print("LiveNotification: failed to sync schedule – ${e.message}");
    }
  }
}

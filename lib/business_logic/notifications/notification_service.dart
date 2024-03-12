import 'package:cakeday_reminder/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static const String channelId = 'birthday_channel';
  static const String channelName = 'Birthday notifications';

  Future scheduleNotification(
      int id, String title, String body, DateTime date) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(date, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(channelId, channelName),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

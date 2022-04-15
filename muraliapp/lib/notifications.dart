import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createExpiryNotification(
    int Id, String name, NotificationCalendar notificationschedule) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: Id,
      channelKey: 'scheduled_channel',
      title: 'Expiring Tomorrow',
      body: 'Your product ' +
          name +
          ' is going to be expired tomorrow. Please use it today or remove it.',
    ),
    /*actionButtons: [
      NotificationActionButton(
        key: 'Mark_Done',
        label: 'Mark Done',
      )
    ],*/
    schedule: NotificationCalendar(
      year: notificationschedule.year,
      month: notificationschedule.month,
      day: notificationschedule.day,
      hour: notificationschedule.hour,
      minute: notificationschedule.minute,
      second: 0,
      millisecond: 0,
      timeZone: notificationschedule.timeZone,
    ),
  );
}

Future<void> cancelScheduledNotifications(int id) async {
  await AwesomeNotifications().cancel(id);
}

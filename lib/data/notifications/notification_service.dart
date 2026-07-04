import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:owndo/domain/entities/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
      linux: linuxSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  Future<void> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();
    final canScheduleExactAlarms =
        await android?.canScheduleExactNotifications() ?? false;
    if (!canScheduleExactAlarms) {
      await android?.requestExactAlarmsPermission();
    }

    final darwin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await darwin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleReminder(Task task) async {
    if (task.reminderAt == null) return;
    final scheduledDate = tz.TZDateTime.fromMillisecondsSinceEpoch(
      tz.local,
      task.reminderAt! * 1000,
    );
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canScheduleExactAlarms =
        await android?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id: _idFor(task.id),
      title: task.title,
      body: task.deadline != null
          ? 'Due ${_formatDate(DateTime.fromMillisecondsSinceEpoch(task.deadline! * 1000))}'
          : 'Task reminder',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Reminders for tasks',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: canScheduleExactAlarms
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(String taskId) async {
    await _plugin.cancel(id: _idFor(taskId));
  }

  int _idFor(String taskId) => taskId.hashCode & 0x7FFFFFFF;

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

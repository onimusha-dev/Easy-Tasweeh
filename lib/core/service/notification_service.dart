import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _handleNotificationResponseStatic,
    );

    requestPermissions(); // Ensure permissions are requested (non-blocking)

    _isInitialized = true;
  }

  static void _handleNotificationResponse(NotificationResponse response) {
    _handleNotificationResponseStatic(response);
  }

  @pragma('vm:entry-point')
  static void _handleNotificationResponseStatic(NotificationResponse response) {
    debugPrint('Notification response received: ${response.payload}');
    // If it's a restore success notification, any click (action or tap) should exit
    if (response.payload == 'restore_success_payload') {
      debugPrint('Exiting app for manual restart...');
      SystemNavigator.pop();
    }
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    // Request notification permission (Android 13+)
    await androidImplementation?.requestNotificationsPermission();

    // Request exact alarm permission (Android 13+)
    // Note: On Android 14+, this is required for exact notifications
    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } catch (e) {
      debugPrint('Error requesting exact alarm permission: $e');
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_isInitialized) await init();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel_id',
            'Daily Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Error scheduling exact notification: $e. Falling back to inexact.');
      // Fallback to inexact if exact is not allowed
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel_id',
            'Daily Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> showInstantBackupAndRestoreNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      if (!_isInitialized) await init();
      // Only request permissions if we haven't checked recently or if needed.
      // However, for instant notifications, it's safer to ensure they are enabled.
      // We'll skip the await for permissions here to avoid blocking the notification display
      // if the permission was already granted.
      requestPermissions(); 

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'instant_backup_and_restore_channel_id',
            'Backup and restore',
            importance: Importance.max,
            priority: Priority.high,
            actions: null,
          );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails();

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosNotificationDetails,
      );

      debugPrint('Showing notification: id=$id, title=$title');
      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: payload ?? 'info_notification',
      );
      debugPrint('Notification shown successfully');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> showBackupSuccessNotification() async {
    await showInstantBackupAndRestoreNotification(
      id: 101,
      title: 'Backup Successful',
      body: 'Your data has been safely saved to your chosen location.',
    );
  }

  Future<void> showBackupErrorNotification(String error) async {
    await showInstantBackupAndRestoreNotification(
      id: 102,
      title: 'Backup Failed',
      body: 'Could not create backup: $error',
    );
  }

  Future<void> showRestoreSuccessNotification() async {
    await showInstantBackupAndRestoreNotification(
      id: 103,
      title: 'Restore Successful',
      body: 'Data restored. Tap this notification to restart the app.',
      payload: 'restore_success_payload',
    );
  }

  Future<void> showRestoreErrorNotification(String error) async {
    await showInstantBackupAndRestoreNotification(
      id: 104,
      title: 'Restore Failed',
      body: 'Could not restore from file: $error',
    );
  }

  Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
    bool indeterminate = false,
  }) async {
    try {
      if (!_isInitialized) await init();
      requestPermissions();

      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'progress_channel_id',
            'Progress Tracking',
            channelDescription: 'Showing progress of long running tasks',
            importance: Importance.low,
            priority: Priority.low,
            showProgress: true,
            maxProgress: maxProgress,
            progress: progress,
            indeterminate: indeterminate,
            onlyAlertOnce: true,
            ongoing: true, // Prevent user from swiping it away during progress
          );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Error showing progress notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}

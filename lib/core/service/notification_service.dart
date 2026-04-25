import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

    await requestPermissions(); // Ensure permissions are requested

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

    await androidImplementation?.requestNotificationsPermission();

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
  }

  Future<void> showInstantBackupAndRestoreNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await init();
    await requestPermissions(); // Safety check for permissions before showing

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

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload ?? 'info_notification',
    );
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
}

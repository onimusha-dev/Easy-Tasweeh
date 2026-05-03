import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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

    try {
      // Initialize timezones
      tz.initializeTimeZones();
      try {
        // Get the device's timezone string
        final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
      } catch (e) {
        debugPrint('Could not set local location, falling back to UTC: $e');
        tz.setLocalLocation(tz.getLocation('UTC'));
      }

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

      _isInitialized = true;
      
      // Request permissions in the background after initialization
      requestPermissions().catchError((e) {
        debugPrint('Background permission request failed: $e');
      });
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
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

    // Request ignore battery optimizations (Android 6+)
    // This helps prevent system from delaying or killing notifications
    try {
      if (await Permission.ignoreBatteryOptimizations.isDenied) {
        await Permission.ignoreBatteryOptimizations.request();
      }
    } catch (e) {
      debugPrint('Error requesting ignore battery optimization: $e');
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
    String? channelId,
    String? channelName,
    String? payload,
  }) async {
    if (!_isInitialized) await init();

    final now = DateTime.now();
    
    // Create a local DateTime to correctly compare with 'now' for wall clock scheduling
    final scheduledDateLocal = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Create the TZDateTime for the plugin, using the same components
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDateLocal.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channelId ?? 'daily_reminder_channel_id',
            channelName ?? 'Daily Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } catch (e) {
      debugPrint(
        'Error scheduling exact notification: $e. Falling back to inexact.',
      );
      // Fallback to inexact if exact is not allowed
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channelId ?? 'daily_reminder_channel_id',
            channelName ?? 'Daily Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
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

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'instant_backup_and_restore_channel_id',
            'System Notifications',
            importance: Importance.max,
            priority: Priority.high,
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

  Future<void> showRateAppNotification() async {
    await showInstantBackupAndRestoreNotification(
      id: 999,
      title: 'Enjoying Easy Tasbeeh?',
      body: 'Tap to rate the app and help us improve!',
      payload: 'rate_app_payload',
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

  Future<void> cancelNotificationsWithPrefix(int startId, int endId) async {
    final List<Future<void>> tasks = [];
    for (int i = startId; i <= endId; i++) {
      tasks.add(flutterLocalNotificationsPlugin.cancel(id: i));
    }
    await Future.wait(tasks);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}

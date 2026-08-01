import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Always-visible logging (works in release APK too — printed to logcat).
void _log(String message) {
  print('[LocalNotification] $message');
}

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  Future<void>? _initFuture;

  Future<void> initialize() {
    if (_isInitialized) {
      _log('initialize: already initialized');
      return Future.value();
    }
    return _initFuture ??= _doInitialize().whenComplete(() {
      // Allow retry if plugin init failed, so a later call can recover.
      if (!_isInitialized) _initFuture = null;
    });
  }

  Future<void> _doInitialize() async {
    // 1) Timezone setup (best effort — must never block notification init)
    try {
      tz.initializeTimeZones();
      final String timeZoneName = await _resolveTimeZoneName();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      _log('initialize: timezone resolved -> $timeZoneName (tz.local: ${tz.local})');
    } catch (e) {
      _log('initialize: timezone init ERROR -> $e');
    }

    // 2) Plugin init — the only step that is actually required
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _log('notification tapped: payload=${response.payload} id=${response.id}');
        },
      );
      _isInitialized = true;
      _log('initialize: plugin initialized successfully');
    } catch (e) {
      _log('initialize: plugin init ERROR -> $e');
      return;
    }

    // 3) Android extras (best effort, each isolated so failures never
    //    poison the whole initialization)
    final AndroidFlutterLocalNotificationsPlugin? android =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'medication_reminders_channel',
        'تذكيرات الأدوية',
        description: 'إشعارات وتنبيهات مواعيد الأدوية والجرعات اليومية',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await android.createNotificationChannel(channel);
      _log('initialize: channel "medication_reminders_channel" created');
    } catch (e) {
      _log('initialize: channel creation ERROR -> $e');
    }

    try {
      final bool? enabled = await android.areNotificationsEnabled();
      _log('initialize: notifications enabled = $enabled');
      if (enabled == false) {
        await android.requestNotificationsPermission();
      }
    } catch (e) {
      _log('initialize: notifications permission ERROR -> $e');
    }
  }

  /// Resolves the device timezone name. Returns a name the tz database
  /// understands; falls back to a location matching the device UTC offset
  /// if the platform returns an unknown/unusable identifier.
  Future<String> _resolveTimeZoneName() async {
    try {
      final dynamic tzInfo = await FlutterTimezone.getLocalTimezone();
      final String? identifier = tzInfo is String
          ? tzInfo
          : (tzInfo is TimezoneInfo ? tzInfo.identifier : null);
      if (identifier != null && identifier.isNotEmpty) {
        if (tz.timeZoneDatabase.locations.containsKey(identifier)) {
          _log('resolveTimeZoneName: platform returned "$identifier"');
          return identifier;
        }
        _log('resolveTimeZoneName: unknown identifier "$identifier", using offset fallback');
      } else {
        _log('resolveTimeZoneName: no usable identifier, using offset fallback');
      }
    } catch (e) {
      _log('resolveTimeZoneName: getLocalTimezone ERROR -> $e, using offset fallback');
    }
    return _findLocationByOffset();
  }

  String _findLocationByOffset() {
    final Duration offset = DateTime.now().timeZoneOffset;
    String? match;
    for (final location in tz.timeZoneDatabase.locations.values) {
      if (location.currentTimeZone.offset == offset) {
        // Prefer a named region so DST rules behave like the device.
        if (location.name.startsWith(RegExp(r'^(Africa|Asia|Europe|America|Australia)/'))) {
          match = location.name;
          break;
        }
        match ??= location.name;
      }
    }
    _log('findLocationByOffset: device offset $offset -> "${match ?? 'UTC'}"');
    return match ?? 'UTC';
  }

  /// Best-effort permission requests, meant to be called from a user-action
  /// context (e.g. when adding a reminder), never from app startup.
  Future<void> requestPermissionsForReminders() async {
    await initialize();
    final AndroidFlutterLocalNotificationsPlugin? android =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    try {
      final bool? enabled = await android.areNotificationsEnabled();
      _log('requestPermissions: notifications enabled before = $enabled');
      if (enabled == false) {
        final bool? granted = await android.requestNotificationsPermission();
        _log('requestPermissions: requestNotificationsPermission result = $granted');
      }
    } catch (e) {
      _log('requestPermissions: requestNotificationsPermission ERROR -> $e');
    }

    try {
      final bool? canExact = await android.canScheduleExactNotifications();
      _log('requestPermissions: canScheduleExactNotifications before = $canExact');
      if (canExact == false) {
        // Opens the "Alarms & reminders" settings on Android 12+
        await android.requestExactAlarmsPermission();
        final bool? after = await android.canScheduleExactNotifications();
        _log('requestPermissions: canScheduleExactNotifications after request = $after');
      }
    } catch (e) {
      _log('requestPermissions: requestExactAlarmsPermission ERROR -> $e');
    }
  }

  /// Returns the schedule mode to use: exact when the OS allows it,
  /// otherwise falls back to inexact so the reminder is still scheduled
  /// instead of failing silently (exact_alarms_not_permitted).
  Future<AndroidScheduleMode> resolveScheduleMode() async {
    try {
      await initialize();
      final AndroidFlutterLocalNotificationsPlugin? android =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? canExact = await android?.canScheduleExactNotifications();
      _log('resolveScheduleMode: canScheduleExactNotifications = $canExact');
      if (canExact == true) {
        return AndroidScheduleMode.exactAllowWhileIdle;
      }
    } catch (e) {
      _log('resolveScheduleMode: ERROR -> $e');
    }
    _log('resolveScheduleMode: falling back to inexactAllowWhileIdle');
    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await initialize();

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'medication_reminders_channel',
        'تذكيرات الأدوية',
        channelDescription: 'إشعارات وتنبيهات مواعيد الأدوية والجرعات اليومية',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        playSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
      _log('showNotification: SUCCESS id=$id title="$title" body="$body" payload=$payload');
    } catch (e) {
      _log('showNotification: ERROR id=$id title="$title" -> $e');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      await initialize();

      final tz.TZDateTime scheduledTZTime = tz.TZDateTime.from(scheduledTime, tz.local);
      final AndroidScheduleMode scheduleMode = await resolveScheduleMode();
      _log('scheduleNotification: preparing id=$id at $scheduledTZTime mode=$scheduleMode');

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'medication_reminders_channel',
        'تذكيرات الأدوية',
        channelDescription: 'إشعارات وتنبيهات مواعيد الأدوية والجرعات اليومية',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTZTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
      _log('scheduleNotification: SUCCESS id=$id title="$title" at $scheduledTZTime');
    } catch (e) {
      _log('scheduleNotification: ERROR id=$id title="$title" -> $e');
    }
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    try {
      await initialize();

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
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

      final AndroidScheduleMode scheduleMode = await resolveScheduleMode();
      _log('scheduleDailyNotification: preparing id=$id hour=$hour minute=$minute '
          'title="$title" body="$body" scheduledDate=$scheduledDate mode=$scheduleMode');

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'medication_reminders_channel',
        'تذكيرات الأدوية',
        channelDescription: 'إشعارات وتنبيهات مواعيد الأدوية والجرعات اليومية',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: scheduleMode,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );

      _log('scheduleDailyNotification: SUCCESS id=$id for $hour:$minute '
          '(Next: $scheduledDate) mode=$scheduleMode payload=$payload');
    } catch (e) {
      _log('scheduleDailyNotification: ERROR id=$id for $hour:$minute -> $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id: id);
      _log('cancelNotification: SUCCESS id=$id');
    } catch (e) {
      _log('cancelNotification: ERROR id=$id -> $e');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
      _log('cancelAll: SUCCESS');
    } catch (e) {
      _log('cancelAll: ERROR -> $e');
    }
  }
}

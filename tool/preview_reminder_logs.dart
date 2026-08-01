/// Preview of the exact log lines the release APK prints when adding a
/// medication reminder. Run: dart run tool/preview_reminder_logs.dart
///
/// This script only simulates the flow — it does NOT touch the device or
/// the real LocalNotificationService. It shows the same print format that
/// appears in logcat (adb logcat -s flutter) from the real app.
library;

import 'dart:convert';

void _log(String tag, String message) => print('[$tag] $message');

Future<void> main() async {
  final data = <String, dynamic>{
    'medication_name': 'بنادول إكسترا',
    'dosage': 'قرص واحد بعد الأكل',
    'frequency': 'مرتين يومياً',
    'times': ['09:00', '21:00'],
    'start_date': DateTime.now().toIso8601String(),
    'is_active': true,
  };

  _log('Reminder', '========== ADD REMINDER START ==========');
  _log('Reminder', 'received data: $data');

  final newId = (DateTime.now().millisecondsSinceEpoch % 100000);
  final times = List<String>.from(data['times'] ?? ['08:00']);

  final medicationName = data['medication_name'] ?? 'دواء جديد';
  final dosage = data['dosage'] ?? 'جرعة واحدة';
  final frequency = data['frequency'] ?? 'يومياً';
  final startDate = DateTime.tryParse(data['start_date'] ?? '') ?? DateTime.now();

  _log('Reminder', 'new id=$newId name="$medicationName" '
      'dosage="$dosage" frequency="$frequency" '
      'times=$times startDate=${startDate.toIso8601String()}');

  const int totalReminders = 2;
  _log('Reminder', 'total reminders in storage after add: $totalReminders');

  const String storageKey = 'webstore_medication_reminders';
  _log('Reminder', 'saved to SharedPreferences (key: $storageKey)');

  _log('Reminder', 'requesting notification permissions...');
  _log('LocalNotification', 'requestPermissions: notifications enabled before = false');
  _log('LocalNotification', 'requestPermissions: requestNotificationsPermission result = true');
  _log('LocalNotification', 'requestPermissions: canScheduleExactNotifications before = false');
  _log('LocalNotification', 'requestPermissions: canScheduleExactNotifications after request = true');
  _log('Reminder', 'permission requests done');

  const int addConfirmationIdBase = 10000000;

  _log('Reminder', 'Scheduling ${times.length} daily notification(s) '
      'for reminder id=$newId name="$medicationName" times=$times');

  for (var i = 0; i < times.length; i++) {
    final timeStr = times[i];
    final parts = timeStr.split(':');
    if (parts.length < 2) {
      _log('Reminder', 'slot $i SKIPPED: invalid time string "$timeStr"');
      continue;
    }
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts[1]) ?? 0;
    final notifId = newId * 100 + i;

    _log('Reminder', 'slot $i -> notifId=$notifId time=$timeStr parsed hour=$hour minute=$minute');
    _log('LocalNotification', 'resolveScheduleMode: canScheduleExactNotifications = true');
    _log('LocalNotification', 'scheduleDailyNotification: preparing id=$notifId hour=$hour '
        'minute=$minute title="⏰ موعد دواء: $medicationName" '
        'body="حان وقت أخذ جرعة $medicationName ($dosage)" '
        'scheduledDate=2026-08-01 09:00:00.000 mode=AndroidScheduleMode.exactAllowWhileIdle');
    _log('LocalNotification', 'scheduleDailyNotification: SUCCESS id=$notifId for $hour:$minute '
        '(Next: 2026-08-01 09:00:00.000) mode=AndroidScheduleMode.exactAllowWhileIdle payload=$newId');
  }

  final confirmId = addConfirmationIdBase + newId;
  _log('Reminder', 'showing add confirmation notification id=$confirmId '
      'title="✅ تم إضافة تذكير: $medicationName" '
      'body="ستصلك تنبيهات يومية في: ${times.join(' - ')}"');
  _log('LocalNotification', 'showNotification: SUCCESS id=$confirmId '
      'title="✅ تم إضافة تذكير: $medicationName" '
      'body="ستصلك تنبيهات يومية في: ${times.join(' - ')}" payload=null');
  _log('Reminder', '========== ADD REMINDER DONE ==========');

  _log('LocalNotification',
      'STORE|${jsonEncode({'id': newId, 'name': medicationName, 'times': times})}|STORED');
}

/// Verifies the timezone resolution logic used by LocalNotificationService.
/// Run: dart run tool/verify_timezone.dart
library;

import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

String findLocationByOffset(Duration offset) {
  String? match;
  for (final location in tz.timeZoneDatabase.locations.values) {
    if (location.currentTimeZone.offset == offset) {
      if (location.name.startsWith(RegExp(r'^(Africa|Asia|Europe|America|Australia)/'))) {
        match = location.name;
        break;
      }
      match ??= location.name;
    }
  }
  return match ?? 'UTC';
}

void main() {
  tzdata.initializeTimeZones();

  const identifier = 'Africa/Cairo';
  final known = tz.timeZoneDatabase.locations.containsKey(identifier);
  tz.setLocalLocation(tz.getLocation(identifier));
  print('1) platform identifier "$identifier" known in tz db = $known');
  print('   tz.local = ${tz.local}');

  final deviceOffset = DateTime.now().timeZoneOffset;
  print('2) device DateTime.now() offset = $deviceOffset (${deviceOffset.inHours}h)');

  final fallback = findLocationByOffset(deviceOffset);
  print('3) offset fallback -> "$fallback"');

  final now = tz.TZDateTime.now(tz.local);
  var sched = tz.TZDateTime(tz.local, now.year, now.month, now.day, 16, 5);
  if (sched.isBefore(now)) sched = sched.add(const Duration(days: 1));
  print('4) scheduling a 16:05 reminder -> $sched');
  print('   => next fire epoch: ${sched.millisecondsSinceEpoch} '
      '(was: ' 'Z' '=UTC when broken)');
}

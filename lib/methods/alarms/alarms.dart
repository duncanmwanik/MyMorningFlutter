// --------------------------------- Alarm Methods ---------------------------------

// sorts alarms according to time set
import 'dart:collection';

List<String> sortAlarmsByTime(List<String> ls) {
  Map<int, String> mp = {};
  for (String e in ls) {
    mp[int.parse(e.substring(6).split(":").join(""))] = e;
  }
  mp = SplayTreeMap<int, String>.from(mp, (k1, k2) => k1.compareTo(k2));

  return mp.values.toList();
}

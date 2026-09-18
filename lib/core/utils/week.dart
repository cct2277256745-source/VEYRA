/// 一周从周一开始。返回本地时区当天周一 00:00（日期粒度，剥离时分秒）。
library;

DateTime mondayOf(DateTime date) {
  // 必须用本地 DateTime（非 DateTime.utc）：与 drift 存储的本地时间戳
  // 及事件窗口比较保持同一时间轴（Phase 3 第一轮修复的时区错位 Bug）。
  final d = DateTime(date.year, date.month, date.day);
  // Dart: weekday Monday=1..Sunday=7
  return d.subtract(Duration(days: d.weekday - 1));
}

// lib/models/activity.dart

class Activity {
  final DateTime date;
  final String day;
  final String clockIn;
  final String clockOut;
  final String breakStart;
  final String breakOut;
  final bool isToday;

  Activity({
    required this.date,
    required this.day,
    required this.clockIn,
    required this.clockOut,
    required this.breakStart,
    required this.breakOut,
    this.isToday = false,
  });
}
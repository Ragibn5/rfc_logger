import '../constants/log_level.dart';

class LogData {
  final DateTime time;
  final LogLevel level;
  final String message;
  final dynamic data;

  LogData(
    this.time,
    this.level,
    this.message,
    this.data,
  );
}

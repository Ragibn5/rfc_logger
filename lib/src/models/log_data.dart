import '../constants/log_level.dart';

class LogData {
  final DateTime time;
  final LogLevel level;
  final dynamic message;

  LogData(
    this.time,
    this.level,
    this.message,
  );
}

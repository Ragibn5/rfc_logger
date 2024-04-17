import '../formatters/log_formatter_base.dart';
import '../constants/log_level.dart';

class LogFormatter extends LogFormatterBase {
  LogFormatter({required super.stampFormat});

  @override
  String getLogStamp(DateTime time) {
    return stampFormat.format(time);
  }

  @override
  String getLogLevelIndicatorString(LogLevel logLevel) {
    switch (logLevel) {
      case LogLevel.debug:
        return "D";
      case LogLevel.info:
        return "I";
      case LogLevel.warning:
        return "W";
      case LogLevel.error:
        return "E";
    }
  }

  @override
  String getFormattedMessage(DateTime time, LogLevel level, String message) {
    return "[${getLogStamp(time)}] [${getLogLevelIndicatorString(level)}] : $message";
  }
}

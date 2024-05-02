import 'dart:convert';

import 'package:rfc_logger/src/models/log_data.dart';

import '../constants/log_level.dart';
import '../formatters/log_formatter_base.dart';

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
  String getFormattedMessage(dynamic message) {
    return JsonEncoder.withIndent(
      "    ",
      (unEncodableValue) => unEncodableValue.toString(),
    ).convert(message);
  }

  @override
  String getFormattedLog(LogData logData) {
    return "[${getLogStamp(logData.time)}] "
        "[${getLogLevelIndicatorString(logData.level)}] : "
        "${getFormattedMessage(logData.message)}";
  }
}

import 'dart:convert';
import 'dart:io';

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
  String? getFormattedData(dynamic data) {
    if (data == null || data is bool || data is num || data is String) {
      return data;
    }

    return JsonEncoder.withIndent(
      "  ",
      (unEncodableValue) => unEncodableValue.toString(),
    ).convert(data);
  }

  @override
  String getFormattedLog(LogData logData) {
    final ls = _getPlatformLineSeparator();

    var msg = logData.message.trim();
    msg = (msg.isNotEmpty ? msg : "N/A");

    var extra = getFormattedData(logData.data);
    extra = (extra != null ? (extra.isNotEmpty ? extra : null) : null);

    return "[${getLogStamp(logData.time)}] - "
        "[${getLogLevelIndicatorString(logData.level)}] ➜ "
        "${msg.contains(ls) ? "$ls$msg" : msg}"
        "${extra != null ? (extra.contains(ls) ? "$ls$extra$ls" : extra) : "$ls"}";
  }

  String _getPlatformLineSeparator() {
    return Platform.isWindows ? "\n\r" : "\n";
  }
}

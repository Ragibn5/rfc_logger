import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rfc_logger/src/models/log_data.dart';

import '../constants/log_level.dart';

abstract class LogFormatterBase {
  final DateFormat _stampFormat;

  LogFormatterBase({required DateFormat stampFormat})
      : _stampFormat = stampFormat;

  @protected
  String getLogStamp(DateTime time);

  @protected
  String getLogLevelIndicatorString(LogLevel logLevel);

  @protected
  String? getFormattedData(dynamic data);

  @protected
  String getFormattedLog(LogData logData);

  @protected
  DateFormat get stampFormat => _stampFormat;
}

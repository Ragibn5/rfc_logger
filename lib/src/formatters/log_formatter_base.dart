import '../constants/log_level.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

abstract class LogFormatterBase {
  final DateFormat _stampFormat;

  LogFormatterBase({required DateFormat stampFormat}) : _stampFormat = stampFormat;

  @protected
  String getLogStamp(DateTime time);

  @protected
  String getLogLevelIndicatorString(LogLevel logLevel);

  @protected
  String getFormattedMessage(DateTime time, LogLevel level, String message);

  @protected
  DateFormat get stampFormat => _stampFormat;
}

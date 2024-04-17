import '../constants/log_level.dart';
import '../formatters/log_formatter.dart';

import 'package:flutter/foundation.dart';

abstract class LoggerClientBase {
  final LogFormatter _logFormatter;

  LoggerClientBase({
    required LogFormatter logFormatter,
  }) : _logFormatter = logFormatter;

  @protected
  LogFormatter get logFormatter => _logFormatter;

  void log(DateTime time, LogLevel level, String message);
}

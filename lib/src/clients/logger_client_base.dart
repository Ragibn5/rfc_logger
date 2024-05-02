import 'package:flutter/foundation.dart';
import 'package:rfc_logger/src/models/log_data.dart';

import '../formatters/log_formatter.dart';

abstract class LoggerClientBase {
  final LogFormatter _logFormatter;

  LoggerClientBase({
    required LogFormatter logFormatter,
  }) : _logFormatter = logFormatter;

  @protected
  LogFormatter get logFormatter => _logFormatter;

  void log(LogData logData);
}

import 'package:flutter/foundation.dart';
import 'package:rfc_logger/src/models/log_data.dart';

import '../formatters/log_formatter.dart';

abstract class LoggerClientBase {
  final String _clientId;
  final LogFormatter _logFormatter;

  LoggerClientBase({
    required String clientId,
    required LogFormatter logFormatter,
  })  : _clientId = clientId,
        _logFormatter = logFormatter;

  @protected
  LogFormatter get logFormatter => _logFormatter;

  String get clientId => _clientId;

  void log(LogData logData);
}

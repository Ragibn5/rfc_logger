import 'package:flutter/foundation.dart';

import '../../constants/log_level.dart';
import '../../formatters/log_formatter.dart';
import '../logger_client_base.dart';

class ConsoleLogger extends LoggerClientBase {
  ConsoleLogger({required LogFormatter logFormatter})
      : super(logFormatter: logFormatter);

  @override
  void log(DateTime time, LogLevel level, String message) {
    debugPrint(logFormatter.getFormattedMessage(time, level, message));
  }
}

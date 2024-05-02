import 'package:flutter/foundation.dart';
import 'package:rfc_logger/src/models/log_data.dart';

import '../../formatters/log_formatter.dart';
import '../logger_client_base.dart';

class ConsoleLogger extends LoggerClientBase {
  ConsoleLogger({required LogFormatter logFormatter})
      : super(logFormatter: logFormatter);

  @override
  void log(LogData logData) {
    debugPrint(logFormatter.getFormattedLog(logData));
  }
}

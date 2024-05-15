import 'package:flutter/foundation.dart';
import 'package:rfc_logger/src/models/log_data.dart';

import '../../formatters/log_formatter.dart';
import '../logger_client_base.dart';

class ConsoleLogger extends LoggerClientBase {
  static const ID = "console";

  ConsoleLogger({required LogFormatter logFormatter})
      : super(clientId: ID, logFormatter: logFormatter);

  @override
  void log(LogData logData) {
    debugPrint(logFormatter.getFormattedLog(logData));
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:rfc_logger/rfc_logger.dart';

void main() {
  test('Collective-Test', () {
    CompositeLogger logger = getDefaultLogger();
  });
}

CompositeLogger getDefaultLogger() {
  LogFormatter logFormatter = LogFormatter(
    stampFormat: DateFormat("yyyy-MM-dd HH:mm:ss.SSS"),
  );
  return CompositeLogger(loggers: [ConsoleLogger(logFormatter: logFormatter)]);
}

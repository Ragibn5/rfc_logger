import 'clients/console_logger/console_logger.dart';
import 'clients/file_logger/file_logger.dart';
import 'clients/logger_client_base.dart';
import 'constants/log_level.dart';
import 'formatters/log_formatter.dart';
import 'formatters/log_formatter_base.dart';

/// A composite logger that writes logs to multiple log clients.
/// - The library ships with two ready-made log client, [ConsoleLogger] and [FileLogger].
/// Both ensures strict ordering. You may create new clients by extending [LoggerClientBase] class.
/// In case of custom clients, you'll have to maintain the order in the client itself. The library
/// does not do that by itself.
/// - You can customize the log format by extending the [LogFormatterBase] class, but the library
/// also ships with a ready-made one - [LogFormatter].
class CompositeLogger {
  final List<LoggerClientBase> _loggers;

  CompositeLogger({required List<LoggerClientBase> loggers})
      : _loggers = loggers;

  void logDebug(String message) {
    log(LogLevel.debug, message);
  }

  void logInfo(String message) {
    log(LogLevel.info, message);
  }

  void logWarning(String message) {
    log(LogLevel.warning, message);
  }

  void logError(String message) {
    log(LogLevel.error, message);
  }

  void logException({
    required dynamic exception,
    String? prefixMessage,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.error,
      "${prefixMessage != null ? "$prefixMessage -> " : ""}${exception.toString()}"
      "${stackTrace != null ? "\n${stackTrace.toString()}\n\n" : " -> Stack trace unavailable"}",
    );
  }

  void log(LogLevel logLevel, String message) {
    DateTime time = DateTime.now();
    for (int i = 0; i < _loggers.length; ++i) {
      _loggers[i].log(time, logLevel, message);
    }
  }
}

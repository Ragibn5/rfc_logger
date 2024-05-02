import 'package:rfc_logger/src/models/log_data.dart';

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
  final Map<LogLevel, bool> _enabledLevelsMap;

  CompositeLogger({
    required List<LoggerClientBase> loggers,
    List<LogLevel> logLevels = const [
      LogLevel.debug,
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
    ],
  })  : _loggers = loggers,
        _enabledLevelsMap = _buildLevelMap(logLevels);

  void logDebug(dynamic message, {String? header}) {
    log(LogLevel.debug, header: header, data: message);
  }

  void logInfo(dynamic message, {String? header}) {
    log(LogLevel.info, header: header, data: message);
  }

  void logWarning(dynamic message, {String? header}) {
    log(LogLevel.warning, header: header, data: message);
  }

  void logError(dynamic message, {String? header}) {
    log(LogLevel.error, header: header, data: message);
  }

  void logException({
    String? header,
    StackTrace? stackTrace,
    required dynamic exception,
  }) {
    log(
      LogLevel.error,
      header: header,
      data: exception,
    );
  }

  void log(LogLevel logLevel, {String? header, required dynamic data}) {
    if (_enabledLevelsMap[logLevel] == false) return;
    for (int i = 0; i < _loggers.length; ++i) {
      _loggers[i].log(
        LogData(
          DateTime.now(),
          logLevel,
          header,
          data,
        ),
      );
    }
  }

  /// Set runtime levels filter.
  /// After calling this, any previous filters will be overwritten.
  void setRuntimeLevels(List<LogLevel> newLevels) {
    _enabledLevelsMap.clear();
    for (final element in newLevels) {
      _enabledLevelsMap[element] = true;
    }
  }

  static _buildLevelMap(List<LogLevel> logLevels) {
    Map<LogLevel, bool> enabledLevelMap = {};
    for (final element in logLevels) {
      enabledLevelMap[element] = true;
    }
  }
}

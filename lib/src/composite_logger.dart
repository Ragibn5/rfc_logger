import 'package:rfc_logger/src/constants/platform_constants.dart';
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
  final Map<LogLevel, bool> _enabledLevelsMap;
  final Map<String, LoggerClientBase> _clientMap;

  CompositeLogger({
    required List<LoggerClientBase> clients,
    List<LogLevel> logLevels = const [
      LogLevel.debug,
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
    ],
  })  : _clientMap = _buildLoggerMap(clients),
        _enabledLevelsMap = _buildLevelMap(logLevels);

  void logDebug(String message, {dynamic data}) {
    log(LogLevel.debug, message: message, data: data);
  }

  void logInfo(String message, {dynamic data}) {
    log(LogLevel.info, message: message, data: data);
  }

  void logWarning(String message, {dynamic data}) {
    log(LogLevel.warning, message: message, data: data);
  }

  void logError(String message, {dynamic data}) {
    log(LogLevel.error, message: message, data: data);
  }

  void logException(
    String message, {
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    log(
      LogLevel.error,
      message: message,
      data: "$exception${PlatformConstants.newLine}$stackTrace",
    );
  }

  /// Writes the supplied log on all the currently available log
  /// clients (if the supplied level is in the current level configuration).
  /// If you want to enable or disable certain log levels, use [setRuntimeLevels].
  void log(
    LogLevel logLevel, {
    required String message,
    dynamic data,
  }) {
    if (_enabledLevelsMap[logLevel] == false) return;
    _clientMap.forEach((key, current) {
      current.log(
        LogData(
          DateTime.now(),
          logLevel,
          message,
          data,
        ),
      );
    });
  }

  /// Adds the supplied client to the list of clients of this instance.
  /// <br><br>
  /// Note:
  /// This operation replaces any existing client with the same client-id.
  /// It is your responsibility to dispose any resources held by a client
  /// before replacing or removing them.
  /// Failing to do so may cause memory leaks and other consequences.
  void addLogger(LoggerClientBase client) {
    _clientMap[client.clientId] = client;
  }

  /// Removes the clients with the supplied client-id(s). If there are multiple
  /// clients with the same ID, all will be deleted.
  /// If no match found, none will be removed.
  /// <br><br>
  /// Note:
  /// It is your responsibility to dispose any resources held by a client
  /// before replacing or removing them.
  /// Failing to do so may cause memory leaks and other consequences.
  void removeLogger(String clientId) {
    _clientMap.removeWhere((key, value) => key == clientId);
  }

  /// Get all the currently active clients.
  LoggerClientBase? getLoggerForId(String clientId) {
    return _clientMap[clientId];
  }

  /// Get all the currently active clients.
  List<LoggerClientBase> getAllLoggers() {
    return _clientMap.values.toList();
  }

  /// Set runtime levels filter.
  /// After calling this, any previous filters will be overwritten.
  void setRuntimeLevels(List<LogLevel> newLevels) {
    _enabledLevelsMap.clear();
    for (final element in newLevels) {
      _enabledLevelsMap[element] = true;
    }
  }

  static _buildLoggerMap(List<LoggerClientBase> logClients) {
    Map<String, LoggerClientBase> clientMap = {};
    for (final current in logClients) {
      clientMap[current.clientId] = current;
    }
    return clientMap;
  }

  static _buildLevelMap(List<LogLevel> logLevels) {
    Map<LogLevel, bool> enabledLevelMap = {};
    for (final element in logLevels) {
      enabledLevelMap[element] = true;
    }
    return enabledLevelMap;
  }
}

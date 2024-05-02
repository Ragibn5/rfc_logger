import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../formatters/log_formatter.dart';
import '../../models/log_data.dart';
import '../logger_client_base.dart';
import 'log_file_config.dart';

class FileLogger extends LoggerClientBase {
  final LogFilConfig _logFileConfig;

  // log queue
  final Queue<LogData> _logQueue = ListQueue(0);

  // flags
  bool _processing = false;

  FileLogger({
    required LogFormatter formatter,
    required LogFilConfig fileConfig,
  })  : _logFileConfig = fileConfig,
        super(logFormatter: formatter);

  @override
  void log(LogData logData) async {
    // add to queue
    _logQueue.addLast(logData);

    // schedule batch log
    await _batchLogInternal();
  }

  Future<void> _batchLogInternal() async {
    // if another data arrives while we are processing current log,
    // we'll skip for now as we are going to run it after finishing the current one.
    if (_processing) return;

    // mark as processing
    _processing = true;

    while (_logQueue.isNotEmpty) {
      await _logInternal(_logQueue.removeFirst());
    }

    // mark as NOT processing
    _processing = false;
  }

  Future<bool> _logInternal(LogData newLogData) async {
    final logFile = await _createLogFile(newLogData.time);
    return logFile != null &&
        await _appendToLogFile(
          logFile,
          logFormatter.getFormattedLog(newLogData),
        );
  }

  /// Append the current log to the log file.
  /// The log will be appended by a platform specific line separator.
  Future<bool> _appendToLogFile(File logFile, String content) async {
    bool success = true;
    try {
      await logFile.writeAsString(
        mode: FileMode.append,
        "$content${Platform.isWindows ? "\r\n" : "\n"}",
      );
    } catch (e, st) {
      success = false;
      debugPrintStack(label: e.toString(), stackTrace: st);
    }
    return success;
  }

  /// Get the log file reference.
  /// If does not exist, will be created and returned.
  Future<File?> _createLogFile(DateTime time) async {
    File? logFile;
    try {
      logFile = await File(_getLogFilePath(time)).create(recursive: true);
    } catch (e, st) {
      debugPrintStack(label: e.toString(), stackTrace: st);
    }
    return logFile;
  }

  String _getLogFilePath(DateTime time) {
    return "${_logFileConfig.parentDir.path}${Platform.pathSeparator}${_getLogFileName(time)}";
  }

  String _getLogFileName(DateTime time) {
    return "${_logFileConfig.fileNamePrefix}"
        "${_logFileConfig.nameDateFormat.format(time)}"
        "${_logFileConfig.fileNameSuffix}";
  }
}

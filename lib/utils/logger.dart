import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._internal();

  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;

  late final Logger _logger;

  static void init({Level level = Level.verbose, bool withStackTrace = true}) {
    final printer = PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    );

    _instance._logger = Logger(
      printer: printer,
      level: level,
    );

  }

  void verbose(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  void exception(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.wtf(message, error, stackTrace);
  }
}

final _log = AppLogger();

void logVerbose(String message, [Object? error, StackTrace? stackTrace]) => _log.verbose(message, error, stackTrace);
void logDebug(String message, [Object? error, StackTrace? stackTrace]) => _log.debug(message, error, stackTrace);
void logInfo(String message, [Object? error, StackTrace? stackTrace]) => _log.info(message, error, stackTrace);
void logWarning(String message, [Object? error, StackTrace? stackTrace]) => _log.warning(message, error, stackTrace);
void logError(String message, [Object? error, StackTrace? stackTrace]) => _log.error(message, error, stackTrace);
void logException(String message, [Object? error, StackTrace? stackTrace]) => _log.exception(message, error, stackTrace);

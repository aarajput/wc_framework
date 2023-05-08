import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

class LoggingUtils {
  static var _ignoreLoggerNames = <String>[];

  static void initialize({
    final List<String> ignoreLoggerNames = const [],
  }) {
    _ignoreLoggerNames = ignoreLoggerNames;
    ansiColorDisabled = false;
    Logger.root.level = Level.OFF;
    assert(
      () {
        Logger.root.level = Level.ALL;
        return true;
      }(),
    );
    Logger.root.onRecord.listen((final record) {
      AnsiPen? pen;
      if (record.level == Level.SEVERE) {
        pen = AnsiPen()..red();
      } else if (record.level == Level.WARNING) {
        pen = AnsiPen()..yellow();
      } else if (record.level == Level.INFO) {
        pen = AnsiPen()..blue();
      } else if (record.level == Level.FINE) {
        pen = AnsiPen()..cyan();
      } else if (record.level == Level.FINER) {
        pen = AnsiPen()..green();
      } else if (record.level == Level.OFF) {
        pen = null;
      } else {
        pen = AnsiPen()..gray();
      }
      if (pen != null && _ignoreLoggerNames.contains(record.loggerName)) {
        pen = null;
      }
      if (pen != null) {
        // ignore: avoid_print
        print(pen('${record.loggerName}: ${record.message}'));
      }
    });
  }
}

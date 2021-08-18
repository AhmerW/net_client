import 'package:flutter/material.dart';

class Log {
  final Widget? trailing;
  final String text;
  final int timestamp = DateTime.now().millisecondsSinceEpoch;

  Log(this.text, {this.trailing});
}

class LogViewController extends ChangeNotifier {
  // key : List<Log>
  Map<int, List<Log>> _logs = {};

  void _checkExists(int key) {
    if (!_logs.containsKey(key)) {
      _logs[key] = [];
    }
  }

  void clear(int key) {
    _logs.remove(key);
  }

  int add(int key, Log log) {
    _checkExists(key);

    _logs[key]!.add(log);
    notifyListeners();
    return _logs[key]!.length - 1;
  }

  List<Log> get(int key) {
    return _logs[key] ?? <Log>[];
  }
}

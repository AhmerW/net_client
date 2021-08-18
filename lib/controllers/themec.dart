import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool _darkTheme = false;
  SharedPreferences? _prefs;

  ThemeController() {
    _getPrefs().then(
      (prefs) {
        _darkTheme = prefs.getBool('isdarktheme') ?? false;
        notifyListeners();
      },
    );
  }
  bool isDarkTheme() => _darkTheme;

  Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  void setDarkTheme(bool value) async {
    _darkTheme = value;
    var prefs = await _getPrefs();
    prefs.setBool('isdarktheme', value);
    notifyListeners();
  }
}

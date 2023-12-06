import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings extends ChangeNotifier {
  static final GlobalSettings _globalSettings = GlobalSettings._();

  bool _volume = true;
  bool _vibration = true;
  bool _inApp = true;

  factory GlobalSettings() {
    return _globalSettings;
  }

  GlobalSettings._() {
    _loadSettings();
  }

  bool get volume => _volume;

  bool get vibration => _vibration;

  bool get inApp => _inApp;

  set volume(bool v) {
    _volume = v;
    _saveSettings();
    notifyListeners();
  }

  set vibration(bool v) {
    _vibration = v;
    _saveSettings();
    notifyListeners();
  }

  set inApp(bool v) {
    _inApp = v;
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _volume = prefs.getBool('volume') ?? true;
    _vibration = prefs.getBool('vibration') ?? true;
    notifyListeners();
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('volume', _volume);
    prefs.setBool('vibration', _vibration);
  }
}

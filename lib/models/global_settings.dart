import 'package:flutter/material.dart';

class GlobalSettings extends ChangeNotifier {

  static final GlobalSettings _globalSettings = GlobalSettings._();

  bool _volume = true;
  bool _vibration = true;

  factory GlobalSettings() {
    return _globalSettings;
  }

  GlobalSettings._();

  bool get volume => _volume;

  bool get vibration => _vibration;

  set volume(bool v) {
    _volume = v;
    notifyListeners();
  }

  set vibration(bool v) {
    _vibration = v;
    notifyListeners();
  }
}